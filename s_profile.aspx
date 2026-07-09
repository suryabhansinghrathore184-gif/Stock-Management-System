<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_profile.aspx.cs" Inherits="StockMangementSystem.WebForm13" %>
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
            <h3 class="fw-bold mb-0 text-dark">Supplier Profile</h3>
            <p class="text-muted small">Update your company details, banking information, GST number, and passwords</p>
        </div>

        <div class="row">
            <!-- Left Card: Company Summary -->
            <div class="col-lg-4 mb-4">
                <div class="card profile-card text-center p-4">
                    <div class="card-body">
                        <asp:Image ID="Image1" runat="server" CssClass="profile-avatar shadow-sm mb-3" />
                        <h4 class="fw-bold text-dark mb-1"><asp:Label ID="LabelNameSummary" runat="server"></asp:Label></h4>
                        <span class="text-muted fw-semibold d-block mb-2"><i class="fa-solid fa-building me-1.5 text-primary"></i><asp:Label ID="LabelCompanySummary" runat="server"></asp:Label></span>
                        <div class="d-block mt-2">
                            <span class='badge bg-success rounded-pill px-3 py-1.5'>
                                <asp:Label ID="LabelStatusSummary" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Card: Profile Tabs -->
            <div class="col-lg-8 mb-4">
                <div class="card profile-card p-4">
                    <ul class="nav nav-tabs nav-tabs-custom mb-4" id="supplierTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="view-tab" data-bs-toggle="tab" data-bs-target="#tab-view" type="button" role="tab">Business Info</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="edit-tab" data-bs-toggle="tab" data-bs-target="#tab-edit" type="button" role="tab">Edit Details</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="bank-tab" data-bs-toggle="tab" data-bs-target="#tab-bank" type="button" role="tab">Bank & GST</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="security-tab" data-bs-toggle="tab" data-bs-target="#tab-security" type="button" role="tab">Security</button>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Tab 1: View details -->
                        <div class="tab-pane fade show active" id="tab-view" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Supplier ID</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label1" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Contact Person</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label4" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Phone Number</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label5" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Email Address</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label6" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">GSTIN / Tax ID</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label9" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">City</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label8" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Bank Account</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="LabelBankAcc" runat="server"></asp:Label></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Bank Name</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="LabelBankName" runat="server"></asp:Label></span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <span class="text-muted small fw-bold text-uppercase d-block">Business Address</span>
                                    <span class="text-dark fw-semibold"><asp:Label ID="Label7" runat="server"></asp:Label></span>
                                </div>
                            </div>
                        </div>

                        <!-- Tab 2: Edit Details -->
                        <div class="tab-pane fade" id="tab-edit" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Supplier Name</label>
                                    <asp:TextBox ID="TxtName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Company Name</label>
                                    <asp:TextBox ID="TxtCompany" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Contact Person</label>
                                    <asp:TextBox ID="TxtContact" runat="server" CssClass="form-control"></asp:TextBox>
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
                                    <label class="form-label fw-semibold">Business Address</label>
                                    <asp:TextBox ID="TxtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row mb-4">
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Company Logo / Picture (Max 5MB)</label>
                                    <asp:FileUpload ID="FuLogo" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <asp:Button ID="BtnUpdateProfile" runat="server" Text="Save Details" CssClass="btn btn-primary" OnClick="BtnUpdateProfile_Click" />
                        </div>

                        <!-- Tab 3: Bank & GST Info -->
                        <div class="tab-pane fade" id="tab-bank" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Bank Name</label>
                                    <asp:TextBox ID="TxtBankName" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Account Number</label>
                                    <asp:TextBox ID="TxtBankAcc" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">IFSC Code</label>
                                    <asp:TextBox ID="TxtBankIfsc" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">GSTIN / Tax ID</label>
                                    <asp:TextBox ID="TxtGst" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                </div>
                            </div>
                            <asp:Button ID="BtnSaveBankInfo" runat="server" Text="Save Bank & GST Details" CssClass="btn btn-primary mt-2" OnClick="BtnSaveBankInfo_Click" />
                        </div>

                        <!-- Tab 4: Security -->
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
