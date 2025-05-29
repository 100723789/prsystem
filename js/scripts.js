document.addEventListener("DOMContentLoaded", function () {

    const token = localStorage.getItem("jwt");
    const role = parseInt(localStorage.getItem("userRole"));
    const sidebarContainer = document.getElementById("sidebar-container");
    const loginForm = document.getElementById("loginForm");
    const registerForm = document.getElementById("registerForm");
    const logoutButton = document.querySelector(".logout-btn");

    if (!token && !loginForm && !registerForm) {
        window.location.href = "login.html";
        return;
    }

    if (sidebarContainer) {
        let links = `<li><a href="index.html">Dashboard</a></li>`;

        if (role === 1) {
            links += `
                <li><a href="vaccination.html">Vaccination Records</a></li>
                <li><a href="users.html">User Management</a></li>
                <li><a href="audit_logs.html">Audit Logs</a></li>
                <li><a href="encryption.html">Encryption Keys</a></li>
                <li><a href="uploads.html">View Uploads</a></li>`;
        } else if (role === 2) {
            links += `
                <li><a href="doctor_appointments.html">My Appointments</a></li>
                <li><a href="vaccination.html">Patient Vaccination Records</a></li>
                <li><a href="upload.html">Upload Reports</a></li>
                <li><a href="uploads.html">View Uploads</a></li>
                <li><a href="profile.html">My Profile</a></li>`;
        } else if (role === 3) {
            links += `
                <li><a href="vaccination.html">My Vaccines</a></li>
                <li><a href="upload.html">Upload a File</a></li>
                <li><a href="profile.html">My Profile</a></li>`;
        }

        sidebarContainer.innerHTML = `<ul>${links}</ul>`;

if (role === 3 && window.location.pathname.includes("index.html")) {
    const dashboard = document.querySelector(".dashboard");

    if (dashboard) {
        dashboard.innerHTML = `
            <div style="display: flex; flex-wrap: wrap; gap: 2rem;">
                <!-- Left Welcome Section -->
                <section class="chart-card public-welcome-card" style="flex: 1; min-width: 300px;">
                    <h2>Welcome to the PRS Portal</h2>
                    <ul class="welcome-actions">
                        <li>Your data is <strong>safe and encrypted</strong> with us.</li>
                        <li>View your <strong>vaccination history</strong> and doses</li>
                        <li><strong>Upload documents</strong> or health files securely</li>
                        <li>Manage your <strong>profile information</strong> and preferences</li>
                        <li>Book an <strong>appointment</strong> with your doctor below</li>
                    </ul>

                    <!-- Book an Appointment Section -->
                    <form id="appointmentForm">
                        <label for="apptDate">Date</label>
                        <input type="date" id="apptDate" required>

<label for="doctorId">Choose Doctor</label>
<select id="doctorId" required>
    <option value="">Loading doctors...</option>
</select>

<label for="apptTime">Choose Time</label>
<select id="apptTime" required>
  <option value="">Select time</option>
</select>

                        <button type="submit" class="form-btn">Confirm</button>
                        <p id="apptMsg" class="form-msg"></p>
                    </form>
                </section>

                <!-- Right Audit Logs Section -->
                <section class="chart-card" style="flex: 1; min-width: 300px;">
                    <h3>My Activity Log</h3>
                    <ul id="auditLogList" class="audit-log-list">
                        <li>Loading activity...</li>
                    </ul>
                </section>
            </div>
        `;

        // Attach event listener after injection
        const form = document.getElementById("appointmentForm");
        if (form) {
            form.addEventListener("submit", function (e) {
                e.preventDefault();
                const date = document.getElementById("apptDate").value;
                const time = document.getElementById("apptTime").value;
                const doctorId = document.getElementById("doctorId").value;
                const msg = document.getElementById("apptMsg");

                fetch("https://prsystem.ct.ws/api/api.php?book-appointment", {
                    


                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "Authorization": "Bearer " + localStorage.getItem("jwt")
                    },
  body: JSON.stringify({ date, time, doctor_id: doctorId })
})
                .then(res => res.json())
                .then(data => {
                    if (data.status === "success") {
                        msg.textContent = data.message;
                        msg.style.color = "#38b000";
                        form.reset();
                        loadUserAuditLogs();
                    } else {
                        msg.textContent = data.error || "Booking failed.";
                        msg.style.color = "red";
                    }
                })
                .catch(err => {
                    console.error("Booking error:", err);
                    msg.textContent = "Something went wrong.";
                    msg.style.color = "red";
                });
            });
        }
        // Load audit logs after the HTML is set
        loadUserAuditLogs();
        loadDoctors();
    }

    return;

}}
    if (logoutButton) {
        logoutButton.addEventListener("click", function () {
            localStorage.clear();
            window.location.href = "login.html";
        });
    }

    if (loginForm) {
        loginForm.addEventListener("submit", function (e) {
            e.preventDefault();
            fetch("https://prsystem.ct.ws/api/api.php?login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    email: document.getElementById("email").value,
                    password: document.getElementById("password").value
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.token) {
                        localStorage.setItem("jwt", data.token);
                        localStorage.setItem("userRole", data.role);
                        localStorage.setItem("userEmail", data.email);
                        window.location.href = "index.html";
                    } else {
                        document.getElementById("loginError").textContent = data.error || "Login failed.";
                    }
                })
                .catch(err => {
                    console.error("Login error:", err);
                    document.getElementById("loginError").textContent = "Something went wrong.";
                });
        });
    }
function loadDoctors() {
  fetch("https://prsystem.ct.ws/api/api.php?doctors", {
    headers: {
      "Authorization": "Bearer " + localStorage.getItem("jwt")
    }
  })
  .then(res => res.json())
  .then(data => {
    const doctorSelect = document.getElementById("doctorId");
    doctorSelect.innerHTML = '<option value="">Select a doctor</option>';

    data.forEach(doctor => {
      const option = document.createElement("option");
      option.value = doctor.user_id;
      option.textContent = doctor.username;
      doctorSelect.appendChild(option);
    });
  })
  .catch(err => {
    console.error("Failed to load doctors", err);
    const doctorSelect = document.getElementById("doctorId");
    doctorSelect.innerHTML = '<option value="">Failed to load doctors</option>';
  });
}

    if (registerForm) {
        registerForm.addEventListener("submit", function (e) {
            e.preventDefault();
            fetch("https://prsystem.ct.ws/api/api.php?users", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    username: document.getElementById("username").value,
                    email: document.getElementById("email").value,
                    password: document.getElementById("password").value,
                    role_id: 3
                })
        })
        .then(res => {
            if (!res.ok) {
                return res.json().then(data => {
                    throw new Error(data.message || "Unexpected error");
                });
            }
            return res.json();
        })
                .then(data => {
                    const msgBox = document.getElementById("message");
                    if (data.status === "success") {
                        msgBox.textContent = "Registration successful! Redirecting...";
                        msgBox.style.color = "green";
                        setTimeout(() => window.location.href = "login.html", 2000);
                    } else {
                        msgBox.textContent = data.message || "Registration failed.";
                        msgBox.style.color = "red";
                    }
                })
                .catch(err => {
                    console.error("Registration error:", err);
                });
        });
    }

    if (document.getElementById("barChart")) {
        fetch("https://prsystem.ct.ws/api/api.php?users", {
            headers: {
                "Authorization": "Bearer " + token
            }
        })
            .then(res => res.json())
            .then(data => {
                const names = data.map(u => u.username);
                const values = data.map(u => u.user_id);

                new Chart(document.getElementById("barChart"), {
                    type: 'bar',
                    data: {
                        labels: names,
                        datasets: [{
                            label: "User IDs",
                            data: values,
                            backgroundColor: "#A8A5C9"
                        }]
                    }
                });

                new Chart(document.getElementById("pieChart"), {
                    type: 'pie',
                    data: {
                        labels: names,
                        datasets: [{
                            data: values,
                            backgroundColor: ['#ACDDDE', '#CAF1DE', '#E1F8DC', '#FEF8DD', '#FFE7C7', '#F7D8BA', '#769FCC', '#F7E6AD', '#D9A5CC', '#AA8FC4']
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { position: 'bottom' }
                        }
                    }
                });

                new Chart(document.getElementById("doughnutChart"), {
                    type: 'doughnut',
                    data: {
                        labels: names,
                        datasets: [{
                            data: values,
                            backgroundColor: ['pink','yellow','blue','orange','purple']
                        }]
                    }
                });

                new Chart(document.getElementById("lineChart"), {
                    type: 'line',
                    data: {
                        labels: names,
                        datasets: [{
                            label: "User IDs",
                            data: values,
                            borderColor: "#BAE5EE",
                            fill: false
                        }]
                    }
                });

                const roleCounts = {};
                data.forEach(user => {
                    roleCounts[user.role_id] = (roleCounts[user.role_id] || 0) + 1;
                });

                new Chart(document.getElementById("radarChart"), {
                    type: 'radar',
                    data: {
                        labels: Object.keys(roleCounts).map(r => "Role " + r),
                        datasets: [{
                            label: "Users by Role",
                            data: Object.values(roleCounts),
                            backgroundColor: "rgba(54, 162, 235, 0.2)",
                            borderColor: "rgba(54, 162, 235, 1)",
                            borderWidth: 2,
                            pointBackgroundColor: "rgba(255, 99, 132, 0.8)",
                            pointRadius: 6,
                            pointHoverRadius: 8,
                            fill: true,
                            tension: 0.4
                        }]
                    }
                });
            }); // this closes .then for charts
        } // this closes if (document.getElementById("barChart"))
    }// this closes document.addEventListener
);

if (window.location.pathname.includes("vaccination.html")) {
    const endpoint = role === 3 ? "my-vaccinations" : "vaccination-records";

    fetch(`https://prsystem.ct.ws/api/api.php?${endpoint}`, {
        headers: {
            "Authorization": "Bearer " + token
        }
    })
    .then(res => res.json())
    .then(data => {
        const tbody = document.querySelector("#vaccinationTable tbody");
        if (!tbody) return;

        if (Array.isArray(data)) {
            data.forEach(record => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${record.vaccine_name}</td>
                    <td>${record.dose_number}</td>
                    <td>${record.date_administered}</td>
                    <td>${record.provider}</td>
                `;
                tbody.appendChild(row);
            });
        } else {
            console.error("Expected array, got:", data);
        }
    })
    .catch(err => {
        console.error("Failed to load vaccination records:", err);
    });
}


function loadAuditLogs() {
  const token = localStorage.getItem("jwt");
  const role = parseInt(localStorage.getItem("userRole"));

  if (role !== 1) {
    alert("Access denied. Admins only.");
    window.location.href = "index.html";
    return;
  }

  fetch("https://prsystem.ct.ws/api/api.php?audit-logs", {
    headers: {
      "Authorization": "Bearer " + token
    }
  })
    .then(res => res.json())
    .then(data => {
      const tbody = document.querySelector("#auditTable tbody");
      tbody.innerHTML = "";

      if (!Array.isArray(data) || data.length === 0) {
        tbody.innerHTML = "<tr><td colspan='4'>No audit logs found.</td></tr>";
        return;
      }

      const userCount = new Set();
      const actionMap = {};
      const userActionCount = {};

      data.forEach(log => {
        const row = document.createElement("tr");
        row.innerHTML = `
          <td>${log.user_id || '-'}</td>
          <td>${log.action}</td>
          <td>${log.entity || '-'}</td>
          <td>${log.record_id || '-'}</td>
          <td>${new Date(log.timestamp).toLocaleString()}</td>
        `;
        tbody.appendChild(row);

        userCount.add(log.user_id);
        actionMap[log.action] = (actionMap[log.action] || 0) + 1;
        userActionCount[log.user_id] = (userActionCount[log.user_id] || 0) + 1;
      });

      const totalLogs = data.length;
      const mostActive = Object.entries(userActionCount).sort((a, b) => b[1] - a[1])[0];

      document.getElementById("totalLogs").textContent = "Total Logs: " + totalLogs;
      document.getElementById("uniqueUsersLog").textContent = "Unique Users: " + userCount.size;
      document.getElementById("mostActiveUser").textContent = "Most Active User ID: " + (mostActive ? mostActive[0] : "N/A");

      new Chart(document.getElementById("actionChart"), {
        type: 'bar',
        data: {
          labels: Object.keys(actionMap),
          datasets: [{
            label: "Audit Actions",
            data: Object.values(actionMap),
            backgroundColor: "#a0c4ff"
          }]
        },
        options: {
          plugins: {
            legend: { display: false }
          }
        }
      });
    })
    .catch(err => {
      console.error("Audit Log Error:", err);
      alert("Error loading audit logs.");
    });
}

function loadUserAuditLogs() {
  const token = localStorage.getItem("jwt");
  if (!token) return;

  fetch("https://prsystem.ct.ws/api/api.php?my-audit", {
    headers: {
      "Authorization": "Bearer " + token
    }
  })
  .then(res => res.json())
  .then(data => {
    const list = document.getElementById("auditLogList");
    list.innerHTML = "";

    if (!Array.isArray(data) || data.length === 0) {
      list.innerHTML = "<li class='audit-entry empty'>No recent activity.</li>";
      return;
    }

    data.forEach(log => {
      const li = document.createElement("li");
      li.className = "audit-entry";

      const time = new Date(log.timestamp).toLocaleString('en-GB', {
        day: '2-digit', month: 'short', year: 'numeric',
        hour: '2-digit', minute: '2-digit'
      });

      let icon = "📝";
      let message = `${log.action} on ${log.entity || "N/A"}`;

      if (log.action.toLowerCase() === "changed password") {
        icon = "🔒";
        message = "You changed your password";
      } else if (log.action.toLowerCase() === "uploaded file") {
        icon = "📤";
        message = "You uploaded a file";
      } else if (log.action.toLowerCase() === "deleted file") {
        icon = "🗑️";
        message = "You deleted a file";
      } else if (log.action.toLowerCase() === "booked appointment") {
        icon = "📅";
        message = `You booked an appointment for <strong>${log.record_id}</strong>`;
      }

      li.innerHTML = `
        <div class="icon">${icon}</div>
        <div>
          <strong>${message}</strong><br>
          <small>${time}</small>
        </div>
      `;

      list.appendChild(li);
    });
  })
  .catch(err => {
    console.error("Audit log fetch failed:", err);
  });
}







function loadEncryptionKeys() {
    const token = localStorage.getItem("jwt");
    const role = parseInt(localStorage.getItem("userRole"));

    if (!token || role !== 1) {
        alert("Access denied.");
        window.location.href = "index.html";
        return;
    }

    fetch("https://prsystem.ct.ws/api/api.php?encryption-keys", {
        headers: { Authorization: "Bearer " + token }
    })
    .then(res => {
        if (!res.ok) throw new Error("Failed to load");
        return res.json();
    })
    .then(data => {
        if (!Array.isArray(data)) throw new Error("Unexpected response");

        const tbody = document.querySelector("#encryptionTable tbody");
        const typeCounts = {};
        const ownerSet = new Set();
        tbody.innerHTML = "";

        data.forEach(key => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${key.key_type}</td>
                <td>${key.owner}</td>
                <td>${key.created_date}</td>`;
            tbody.appendChild(row);

            ownerSet.add(key.owner);
            typeCounts[key.key_type] = (typeCounts[key.key_type] || 0) + 1;
        });

        document.getElementById("totalKeys").textContent = "Total Encryption Keys: " + data.length;
        document.getElementById("uniqueOwners").textContent = "Unique Owners: " + ownerSet.size;
        document.getElementById("mostCommonType").textContent = "Most Common Key Type: " +
            (Object.entries(typeCounts).sort((a, b) => b[1] - a[1])[0]?.[0] || "N/A");

        const ctx = document.getElementById("keyChart").getContext("2d");
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: Object.keys(typeCounts),
                datasets: [{
                    data: Object.values(typeCounts),
                    backgroundColor: ['#ff9999','#66b3ff','#99ff99','#ffcc99']
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    })
    .catch(err => {
        console.error("Failed to load encryption keys", err);
        alert("Error loading encryption keys.");
    });
}



function setupUploadForm() {
  const form = document.getElementById("uploadForm");
  const message = document.getElementById("message");
  const fileInput = document.getElementById("fileInput");
  const fileName = document.getElementById("fileName");

  fileInput.addEventListener("change", () => {
    fileName.textContent = fileInput.files.length > 0 ? fileInput.files[0].name : "";
  });

  form.addEventListener("submit", async function (e) {
    e.preventDefault();
    message.textContent = "";

    const token = localStorage.getItem("jwt");
    if (!token) {
      message.textContent = "Upload failed: Please login.";
      message.style.color = "red";
      return;
    }

    const formData = new FormData(form);
    try {
const res = await fetch("/api/api.php?upload=true", {
  method: "POST",
  headers: {
    Authorization: "Bearer " + token
  },
  body: formData
});

    const text = await res.text();
    console.log("Upload raw response:", text);
    let data;
    try {
    data = JSON.parse(text);
    } catch (e) {
    throw new Error("Invalid JSON from server:\n" + text);
    }

      if (res.ok) {
        message.textContent = "Upload successful: " + data.file_path;
        message.style.color = "green";
        form.reset();
        fileName.textContent = "";
      } else {
        message.textContent = "Upload failed: " + (data.error || "Unknown error");
        message.style.color = "red";
      }
    } catch (err) {
      console.error("Upload error:", err);
      message.textContent = "Upload failed: Something went wrong.";
      message.style.color = "red";
    }
  });
}

function setupUploadsView() {
  const token = localStorage.getItem("jwt");
  if (!token) {
    alert("You must be logged in.");
    window.location.href = "login.html";
    return;
  }

  const payload = JSON.parse(atob(token.split('.')[1]));
  const currentUserRole = payload.data.role_id;

  if (currentUserRole !== 1 && currentUserRole !== 2) {
    alert("Access denied.");
    window.location.href = "index.html";
    return;
  }

  loadFiles(currentUserRole);
}
function loadFiles(currentUserRole) {
  fetch("https://prsystem.ct.ws/api/api.php?uploads", {
    headers: { Authorization: "Bearer " + localStorage.getItem("jwt") }
  })
    .then(res => res.json())
    .then(data => {
      const list = document.getElementById("fileList");
      list.innerHTML = "";

      if (!Array.isArray(data)) throw new Error("Invalid response format");

      data.forEach(file => {
        const li = document.createElement("li");

        const link = document.createElement("a");
        link.href = "/api/uploads/" + file.file_path;
        link.textContent = file.file_path;
        link.target = "_blank";
        
        const downloadBtn = document.createElement("a");
        downloadBtn.href = link.href;
        downloadBtn.download = file.file_path;
        downloadBtn.textContent = "Download";
        downloadBtn.className = "form-btn";
        downloadBtn.style.marginLeft = "10px";

const buttonGroup = document.createElement("div");
buttonGroup.style.display = "flex";
buttonGroup.style.gap = "10px";


buttonGroup.appendChild(downloadBtn);

if (currentUserRole === 1) {
  const delBtn = document.createElement("button");
  delBtn.textContent = "Delete";
  delBtn.className = "delete-btn";
  delBtn.onclick = () => deleteFile(file.file_path.split("/").pop());
  buttonGroup.appendChild(delBtn);
}

li.appendChild(link);         // File name stays on the left
li.appendChild(buttonGroup); // Buttons now grouped cleanly on the right


        list.appendChild(li);
      });
    })
    .catch(err => {
      console.error("Failed to load file list", err);
      alert("An error occurred while loading the file list.");
    });
}



function deleteFile(filename) {
  const confirmed = confirm(`Are you sure you want to delete "${filename}"?`);
  if (!confirmed) return;

fetch("https://prsystem.ct.ws/api/api.php?delete-upload", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + localStorage.getItem("jwt")
    },
    body: JSON.stringify({ filename: "api/uploads/" + filename })

  })
  .then(async res => {
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || data.message || "Unknown error");

    alert("File deleted successfully.");
    setupUploadsView(); // refresh list
  })
  .catch(err => {
    console.error("Delete failed", err);
    alert("An error occurred while deleting the file.");
  });
}




document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("bookAppointmentForm");

  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      const date = document.getElementById("apptDate").value;
      const time = document.getElementById("apptTime").value;
      const msg = document.getElementById("apptMsg");

      fetch("https://prsystem.ct.ws/api/api.php?book-appointment", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + localStorage.getItem("jwt")
        },
        body: JSON.stringify({ date, time })
      })
        .then(res => res.json())
        .then(data => {
          if (data.status === "success") {
            msg.textContent = data.message;
            msg.style.color = "#38b000";
            form.reset();
          } else {
            msg.textContent = data.error || "Booking failed.";
            msg.style.color = "red";
          }
        })
        .catch(err => {
          console.error("Booking error:", err);
          msg.textContent = "Something went wrong.";
          msg.style.color = "red";
        });
    });
  }
});



document.addEventListener("DOMContentLoaded", function () {
  const dateInput = document.getElementById("apptDate");
  const doctorInput = document.getElementById("doctorId");
  const timeDropdown = document.getElementById("apptTime");

  if (!dateInput || !doctorInput || !timeDropdown) return;

  dateInput.addEventListener("change", fetchAvailableSlots);
  doctorInput.addEventListener("change", fetchAvailableSlots);

  function fetchAvailableSlots() {
    const date = dateInput.value;
    const doctorId = doctorInput.value;

    if (!date || !doctorId) {
      console.warn("Date or doctor not selected yet.");
      return;
    }

    console.log("Fetching slots for:", date, "Doctor:", doctorId);
    fetch("https://prsystem.ct.ws/api/api.php?action=available-times", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ date, doctor_id: doctorId })
    })
      .then(res => res.json())
      .then(data => {
        console.log("Response from API:", data);
        timeDropdown.innerHTML = `<option value="">Select time</option>`;
        if (data.available_times && Array.isArray(data.available_times)) {
          data.available_times.forEach(time => {
            const option = document.createElement("option");
            option.value = time;
            option.textContent = time;
            timeDropdown.appendChild(option);
          });
        } else {
          timeDropdown.innerHTML = `<option value="">No available times</option>`;
        }
      })
      .catch(err => {
        console.error("Fetch error:", err);
      });
  }
});




function logout() {
    localStorage.removeItem("jwt");
    localStorage.removeItem("userRole");
    localStorage.removeItem("userEmail");
    window.location.href = "login.html";
}