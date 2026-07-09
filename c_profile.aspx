<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_profile.aspx.cs" Inherits="StockMangementSystem.WebForm15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #e2e8f0;
        }
        .nav-tabs-custom .nav-link {
            border: none;
            color: #64748b;
            font-weight: 500;
            padding: 12px 20px;
            border-bottom: 2px solid transparent;
        }
        .nav-tabs-custom .nav-link.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
            background: transparent;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">My Profile</h3>
            <p class="text-muted small">Manage your account information, upload picture, and update password</p>
        </div>

        <div class="row">
            <!-- Left Card: Profile Avatar Summary -->
            <div class="col-lg-4 mb-4">
                <div class="card profile-card text-center p-4">
                    <div class="card-body">
                        <asp:Image ID="Image1" runat="server" CssClass="profile-avatar shadow-sm mb-3" />
                        <h4 class="fw-bold text-dark mb-1"><asp:Label ID="LabelNameSummary" runat="server"></asp:Label></h4>
                        <span class="badge bg-primary rounded-pill px-3 py-1.5 mb-2"><asp:Label ID="LabelTypeSummary" runat="server"></asp:Label></span>
                        <div class="d-block mt-2">
                            <span class='badge bg-success rounded-pill px-3 py-1.5'>
                                <asp:Label ID="LabelStatusSummary" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Card: Form Tabs -->
            <div class="col-lg-8 mb-4">
                <div class="card profile-card p-4">
                    <!-- Nav Tabs -->
                    <ul class="nav nav-tabs nav-tabs-custom mb-4" id="profileTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="view-tab" data-bs-toggle="tab" data-bs-target="#tab-view" type="button" role="tab">Account Info</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="edit-tab" data-bs-toggle="tab" data-bs-target="#tab-edit" type="button" role="tab">Edit Details</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="security-tab" data-bs-toggle="tab" data-bs-target="#tab-security" type="button" role="tab">Security</button>
                        </li>
                    </ul>

                    <!-- Tab Contents -->
                    <div class="tab-content">
                        <!-- Tab 1: View Details -->
                        <div class="tab-pane fade show active" id="tab-view" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Customer ID</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label1" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Phone Number</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label3" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Email Address</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label4" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">GSTIN / Tax ID</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label7" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Credit Limit</span>
                                    <span class="text-success fw-bold">$<asp:Label ID="Label9" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">City</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label6" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Billing Address</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label5" runat="server"></asp:Label></span>
                                </div>
                            </div>
                        </div>

                        <!-- Tab 2: Edit Details -->
                        <div class="tab-pane fade" id="tab-edit" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Customer Name</label>
                                    <asp:TextBox ID="TxtName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Mobile Number</label>
                                    <asp:TextBox ID="TxtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Email Address</label>
                                    <asp:TextBox ID="TxtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">City</label>
                                    <asp:TextBox ID="TxtCity" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Billing Address</label>
                                    <asp:TextBox ID="TxtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row mb-4">
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Profile Photo (Max 5MB)</label>
                                    <asp:FileUpload ID="FuPhoto" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <asp:Button ID="BtnUpdateProfile" runat="server" Text="Save Details" CssClass="btn btn-primary" OnClick="BtnUpdateProfile_Click" />
                        </div>

                        <!-- Tab 3: Security & Password -->
                        <div class="tab-pane fade" id="tab-security" role="tabpanel">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Current Password</label>
                                <asp:TextBox ID="TxtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">New Password</label>
                                <asp:TextBox ID="TxtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Confirm New Password</label>
                                <asp:TextBox ID="TxtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <asp:Button ID="BtnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-danger" OnClick="BtnChangePassword_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
