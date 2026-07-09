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
        .info-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #64748b;
            display: block;
        }
        .info-value {
            font-size: 0.95rem;
            font-weight: 500;
            color: #0f172a;
            display: block;
            margin-bottom: 15px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Supplier Profile</h3>
            <p class="text-muted small">Manage your business account information</p>
        </div>

        <div class="row">
            <!-- Left Profile Card -->
            <div class="col-lg-4 mb-4">
                <div class="card profile-card text-center p-4">
                    <div class="card-body">
                        <asp:Image ID="Image1" runat="server" CssClass="profile-avatar shadow-sm mb-3" />
                        <h4 class="fw-bold text-dark mb-1"><asp:Label ID="Label2" runat="server"></asp:Label></h4>
                        <span class="text-muted fw-semibold d-block mb-2"><i class="fa-solid fa-building me-1.5 text-primary"></i><asp:Label ID="Label3" runat="server"></asp:Label></span>
                        <div class="d-block mt-2">
                            <span class='badge bg-success rounded-pill px-3 py-1.5'>
                                <asp:Label ID="Label10" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Profile Details -->
            <div class="col-lg-8 mb-4">
                <div class="card profile-card p-4">
                    <div class="card-header bg-white border-0 p-0 pb-3 mb-3 border-bottom">
                        <h5 class="fw-bold m-0 text-primary"><i class="fa-solid fa-briefcase me-2"></i>Business Information</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="row">
                            <div class="col-md-6">
                                <span class="info-label">Supplier ID</span>
                                <span class="info-value"><asp:Label ID="Label1" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-md-6">
                                <span class="info-label">Contact Person</span>
                                <span class="info-value"><asp:Label ID="Label4" runat="server"></asp:Label></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <span class="info-label">Mobile Number</span>
                                <span class="info-value"><asp:Label ID="Label5" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-md-6">
                                <span class="info-label">Email Address</span>
                                <span class="info-value"><asp:Label ID="Label6" runat="server"></asp:Label></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <span class="info-label">GSTIN / Tax ID</span>
                                <span class="info-value"><asp:Label ID="Label9" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-md-6">
                                <span class="info-label">City</span>
                                <span class="info-value"><asp:Label ID="Label8" runat="server"></asp:Label></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <span class="info-label">Business Address</span>
                                <span class="info-value"><asp:Label ID="Label7" runat="server"></asp:Label></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
