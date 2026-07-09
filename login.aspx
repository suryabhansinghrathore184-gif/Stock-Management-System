<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="StockMangementSystem.WebForm11" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - Stock Management System</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 20px;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 420px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .login-header {
            background-color: #1e1b4b;
            padding: 30px;
            text-align: center;
            color: #fff;
        }

        .login-header i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #818cf8;
        }

        .login-body {
            padding: 40px 30px;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(79, 70, 229, 0.25);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 12px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
        }

        .alert-custom {
            border-radius: 8px;
            font-size: 0.9rem;
            padding: 10px 15px;
        }

        /* Credentials Assistant */
        .credentials-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            padding: 18px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .credential-badge {
            cursor: pointer;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.15);
            color: #e2e8f0;
            font-size: 0.85rem;
            padding: 6px 12px;
            border-radius: 6px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .credential-badge:hover {
            background: rgba(255, 255, 255, 0.18);
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <i class="fa-solid fa-boxes-stacked"></i>
            <h4 class="m-0 fw-bold">STOCK FLOW</h4>
            <small class="text-white-50">Inventory & Management System</small>
        </div>
        <div class="login-body">
            <form id="form1" runat="server">
                <h5 class="text-center mb-4 fw-semibold text-secondary">Account Login</h5>
                
                <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-custom mb-3" Role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>
                    <asp:Label ID="ErrorMessageLabel" runat="server" Text="Invalid Username or Password"></asp:Label>
                </asp:Panel>

                <div class="mb-3">
                    <label for="TextBox1" class="form-label fw-medium text-muted">Username / ID</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-user"></i></span>
                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control border-start-0 ps-1" placeholder="Enter your User ID" Required="true"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="TextBox2" class="form-label fw-medium text-muted">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-lock"></i></span>
                        <asp:TextBox ID="TextBox2" runat="server" TextMode="Password" CssClass="form-control border-start-0 ps-1" placeholder="Enter your password" Required="true"></asp:TextBox>
                    </div>
                </div>

                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Log In" CssClass="btn btn-primary w-100 shadow-sm" />

                <div class="text-center mt-4">
                    <span class="text-muted small">Need an account? Contact system admin.</span>
                </div>
            </form>
        </div>
    </div>

    <!-- Credentials Assistant Card -->
    <div class="credentials-card">
        <h6 class="text-white text-center mb-3 fw-semibold"><i class="fa-solid fa-key me-2 text-warning"></i>Quick Login Assistant</h6>
        <div class="d-flex flex-column gap-2">
            <div class="credential-badge" onclick="quickFill('admin', '123')">
                <span><i class="fa-solid fa-user-shield text-info me-2"></i><strong>Admin:</strong> admin</span>
                <span class="badge bg-dark-subtle text-white-50 border border-secondary border-opacity-50">PW: 123</span>
            </div>
            <div class="credential-badge" onclick="quickFill('101', '123')">
                <span><i class="fa-solid fa-user-tie text-success me-2"></i><strong>Customer:</strong> 101</span>
                <span class="badge bg-dark-subtle text-white-50 border border-secondary border-opacity-50">PW: 123</span>
            </div>
            <div class="credential-badge" onclick="quickFill('102', '123')">
                <span><i class="fa-solid fa-truck-field text-warning me-2"></i><strong>Supplier:</strong> 102</span>
                <span class="badge bg-dark-subtle text-white-50 border border-secondary border-opacity-50">PW: 123</span>
            </div>
        </div>
        <div class="text-center mt-3">
            <small class="text-white-50" style="font-size: 0.75rem;"><i class="fa-solid fa-circle-info me-1"></i>Click any profile above to auto-fill the form</small>
        </div>
    </div>

    <!-- Auto-fill JavaScript -->
    <script>
        function quickFill(user, pass) {
            document.getElementById('<%= TextBox1.ClientID %>').value = user;
            document.getElementById('<%= TextBox2.ClientID %>').value = pass;
        }
    </script>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
