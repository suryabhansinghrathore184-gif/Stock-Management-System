<%@ Page Title="Add Supplier" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="newsupplier.aspx.cs" Inherits="StockMangementSystem.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .supplier-card {
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
                <h3 class="fw-bold mb-0 text-dark">Supplier Registration</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="supplierlist.aspx">Suppliers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">New Supplier</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card card-premium supplier-card">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-truck-field-un me-2 text-primary"></i>Register Supplier Profile</h5>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <div class="row">
                            <!-- Supplier ID (ReadOnly) -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Supplier ID</label>
                                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox>
                            </div>

                            <!-- Supplier Name -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Supplier Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" placeholder="e.g. Bhavesh Suthar"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqName" runat="server" ControlToValidate="TextBox2" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Company Name -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Company Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" placeholder="e.g. Acme Corp"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCompany" runat="server" ControlToValidate="TextBox3" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Contact Person -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Contact Person</label>
                                <asp:TextBox ID="TextBox4" runat="server" CssClass="form-control" placeholder="e.g. Sales Manager"></asp:TextBox>
                            </div>

                            <!-- Mobile -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Mobile Number <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPhone" runat="server" ControlToValidate="TextBox5" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Alternate Number -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Alternate Phone</label>
                                <asp:TextBox ID="TxtAltNumber" runat="server" CssClass="form-control" placeholder="e.g. 9876543211"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Email -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Email Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox6" runat="server" CssClass="form-control" placeholder="e.g. supplier@domain.com" TextMode="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqEmail" runat="server" ControlToValidate="TextBox6" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Website -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Website URL</label>
                                <asp:TextBox ID="TxtWebsite" runat="server" CssClass="form-control" placeholder="e.g. www.supplier.com"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Address -->
                            <div class="col-md-12 mb-3">
                                <label class="form-label fw-semibold text-muted">Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox7" runat="server" CssClass="form-control" placeholder="e.g. 123 Industrial Area"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqAddress" runat="server" ControlToValidate="TextBox7" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- City -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">City <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox8" runat="server" CssClass="form-control" placeholder="e.g. Udaipur"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCity" runat="server" ControlToValidate="TextBox8" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- State -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">State <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtState" runat="server" CssClass="form-control" placeholder="e.g. Rajasthan"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqState" runat="server" ControlToValidate="TxtState"
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Postal Code -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Postal Code <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPostalCode" runat="server" CssClass="form-control" placeholder="e.g. 313001"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPostal" runat="server" ControlToValidate="TxtPostalCode"
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Country -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Country <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtCountry" runat="server" CssClass="form-control" Text="India"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCountry" runat="server" ControlToValidate="TxtCountry"
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- GSTIN -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">GST Number</label>
                                <asp:TextBox ID="TextBox9" runat="server" CssClass="form-control" placeholder="e.g. 08AAAAA0000A1Z2"></asp:TextBox>
                            </div>

                            <!-- PAN Number -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">PAN Number</label>
                                <asp:TextBox ID="TxtPanNumber" runat="server" CssClass="form-control" placeholder="e.g. ABCDE1234F"></asp:TextBox>
                            </div>

                            <!-- Status -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Status <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Active" Value="Active" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <!-- Password -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Portal Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TextBox10" runat="server" CssClass="form-control" placeholder="Create password" Required="true"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Bank Details -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Bank Details (Optional)</label>
                            <asp:TextBox ID="TxtBankDetails" runat="server" CssClass="form-control" placeholder="e.g. Bank Name, A/C: 123456789, IFSC: SBIN0000123" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </div>

                        <!-- Logo/Photo -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted">Supplier Photograph / Logo</label>
                            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
                            <small class="text-muted d-block mt-1">Leave blank to use default placeholder avatar.</small>
                        </div>

                        <div class="d-flex gap-2">
                            <asp:Button ID="Button1" runat="server" Text="Register Supplier" CssClass="btn btn-primary px-4 py-2" ValidationGroup="SupplierForm" OnClick="Button1_Click" />
                            <a href="supplierlist.aspx" class="btn btn-outline-secondary px-4 py-2">Cancel</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
