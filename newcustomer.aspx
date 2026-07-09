<%@ Page Title="Add Customer" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="newcustomer.aspx.cs" Inherits="StockMangementSystem.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .customer-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Customer Registration</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="customerlist.aspx">Customers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">New Customer</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card card-premium customer-card">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-user-plus me-2 text-primary"></i>Register Customer Profile</h5>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <div class="row">
                            <!-- Customer ID (ReadOnly) -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Customer ID</label>
                                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox>
                            </div>

                            <!-- Customer Name -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Full Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" placeholder="e.g. John Doe"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqName" runat="server" ControlToValidate="TextBox2" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Email -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Email Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox4" runat="server" CssClass="form-control" placeholder="e.g. customer@domain.com" TextMode="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqEmail" runat="server" ControlToValidate="TextBox4" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Mobile -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Mobile Number <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPhone" runat="server" ControlToValidate="TextBox3" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Alt Mobile -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Alternate Mobile</label>
                                <asp:TextBox ID="TxtAltMobile" runat="server" CssClass="form-control" placeholder="e.g. 9876543211"></asp:TextBox>
                            </div>

                            <!-- Company Name -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Company Name (Optional)</label>
                                <asp:TextBox ID="TxtCompany" runat="server" CssClass="form-control" placeholder="e.g. Global Tech"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Address -->
                            <div class="col-md-12 mb-3">
                                <label class="form-label fw-semibold text-muted">Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control" placeholder="e.g. 45 Park Avenue"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqAddress" runat="server" ControlToValidate="TextBox5" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- City -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">City <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Select City" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Udaipur" Value="Udaipur"></asp:ListItem>
                                    <asp:ListItem Text="Jaipur" Value="Jaipur"></asp:ListItem>
                                    <asp:ListItem Text="Mount Abu" Value="Mount Abu"></asp:ListItem>
                                    <asp:ListItem Text="Delhi" Value="Delhi"></asp:ListItem>
                                    <asp:ListItem Text="Mumbai" Value="Mumbai"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ReqCity" runat="server" ControlToValidate="DropDownList1" InitialValue=""
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- State -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">State <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtState" runat="server" CssClass="form-control" placeholder="e.g. Rajasthan"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqState" runat="server" ControlToValidate="TxtState"
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Postal Code -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Postal Code <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPostalCode" runat="server" CssClass="form-control" placeholder="e.g. 313001"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPostal" runat="server" ControlToValidate="TxtPostalCode"
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Country -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Country <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtCountry" runat="server" CssClass="form-control" Text="India"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCountry" runat="server" ControlToValidate="TxtCountry"
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- GSTIN -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">GST Number</label>
                                <asp:TextBox ID="TextBox6" runat="server" CssClass="form-control" placeholder="e.g. 08BBBBB0000B1Z2"></asp:TextBox>
                            </div>

                            <!-- Customer Type -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Customer Type <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Select Type" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Retail" Value="Retail"></asp:ListItem>
                                    <asp:ListItem Text="WholeSale" Value="WholeSale"></asp:ListItem>
                                    <asp:ListItem Text="Distributor" Value="Distributor"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ReqType" runat="server" ControlToValidate="DropDownList2" InitialValue=""
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Credit Limit -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Credit Limit ($) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox7" runat="server" CssClass="form-control" placeholder="0.00" Text="1000.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCredit" runat="server" ControlToValidate="TextBox7" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValCredit" runat="server" ControlToValidate="TextBox7" Type="Double" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid value" CssClass="text-danger small d-block mt-1" ValidationGroup="CustomerForm"></asp:CompareValidator>
                            </div>

                            <!-- Status -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Status <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DropDownList3" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Active" Value="Active" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Password -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Portal Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox8" runat="server" CssClass="form-control" placeholder="Create password" Required="true"></asp:TextBox>
                            </div>

                            <!-- Logo/Photo -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Customer Photograph</label>
                                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
                                <small class="text-muted d-block mt-1">Leave blank to use default placeholder avatar.</small>
                            </div>
                        </div>

                        <div class="d-flex gap-2 mt-3">
                            <asp:Button ID="Button1" runat="server" Text="Register Customer" CssClass="btn btn-primary px-4 py-2" ValidationGroup="CustomerForm" OnClick="Button1_Click" />
                            <a href="customerlist.aspx" class="btn btn-outline-secondary px-4 py-2">Cancel</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
