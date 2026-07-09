<%@ Page Title="Search Customer" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="customersearch.aspx.cs" Inherits="StockMangementSystem.WebForm5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-img-preview {
            width: 110px;
            height: 110px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #e2e8f0;
        }
        .info-label {
            font-size: 0.85rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 600;
            display: block;
        }
        .info-value {
            font-size: 1rem;
            color: #0f172a;
            font-weight: 500;
            display: block;
            margin-bottom: 12px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Find Customer Profile</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="customerlist.aspx">Customers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Search</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Search bar card -->
                <div class="card card-premium mb-4">
                    <div class="card-body">
                        <div class="row align-items-end g-3">
                            <div class="col-md-8">
                                <label class="form-label fw-bold text-muted">Enter Customer ID <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control form-control-lg" placeholder="e.g. 101"></asp:TextBox>
                            </div>
                            <div class="col-md-4 d-flex gap-2">
                                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Search ID" CssClass="btn btn-primary btn-lg w-100" />
                                <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Delete" CssClass="btn btn-outline-danger btn-lg w-100" 
                                    OnClientClick="return confirm('Are you sure you want to permanently delete this customer?');" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Profile Result Card -->
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-address-card me-2 text-primary"></i>Customer Record Details</h5>
                    </div>
                    <div class="card-body text-center text-md-start">
                        <div class="row align-items-center mb-4">
                            <div class="col-md-3 text-center mb-3 mb-md-0">
                                <asp:Image ID="Image1" runat="server" CssClass="profile-img-preview shadow-sm" />
                            </div>
                            <div class="col-md-9">
                                <h4 class="fw-bold text-dark mb-1"><asp:Label ID="Label1" runat="server" Text="-"></asp:Label></h4>
                                <span class="badge bg-primary rounded-pill px-3 py-1.5"><asp:Label ID="Label7" runat="server" Text="Retail"></asp:Label></span>
                            </div>
                        </div>

                        <hr class="text-muted" />

                        <div class="row mt-4">
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">Contact Number</span>
                                <span class="info-value"><asp:Label ID="Label2" runat="server" Text="-"></asp:Label></span>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">Email Address</span>
                                <span class="info-value"><asp:Label ID="Label3" runat="server" Text="-"></asp:Label></span>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">Status</span>
                                <span class="info-value"><asp:Label ID="Label9" runat="server" Text="-"></asp:Label></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-8">
                                <span class="info-label">Full Address</span>
                                <span class="info-value"><asp:Label ID="Label4" runat="server" Text="-"></asp:Label></span>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">City</span>
                                <span class="info-value"><asp:Label ID="Label5" runat="server" Text="-"></asp:Label></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">GSTIN / Tax ID</span>
                                <span class="info-value"><asp:Label ID="Label6" runat="server" Text="-"></asp:Label></span>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">Credit Limit</span>
                                <span class="info-value">$<asp:Label ID="Label8" runat="server" Text="0.00"></asp:Label></span>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <span class="info-label">Access Password</span>
                                <span class="info-value"><asp:Label ID="Label10" runat="server" Text="-"></asp:Label></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
