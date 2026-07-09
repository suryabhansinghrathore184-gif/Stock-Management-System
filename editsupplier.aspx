<%@ Page Title="Edit Supplier" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="editsupplier.aspx.cs" Inherits="StockMangementSystem.editsupplier" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .supplier-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .current-photo-preview {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #e2e8f0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Edit Supplier Profile</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="supplierlist.aspx">Suppliers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Edit Supplier</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card card-premium supplier-card">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-user-pen me-2 text-primary"></i>Modify Supplier Details</h5>
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
                                <asp:TextBox ID="TxtId" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox>
                            </div>

                            <!-- Supplier Name -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Supplier Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtName" runat="server" CssClass="form-control" placeholder="e.g. John Doe"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqName" runat="server" ControlToValidate="TxtName" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Company Name -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Company Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtCompany" runat="server" CssClass="form-control" placeholder="e.g. Acme Corp"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCompany" runat="server" ControlToValidate="TxtCompany" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Contact Person -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Contact Person</label>
                                <asp:TextBox ID="TxtContact" runat="server" CssClass="form-control" placeholder="e.g. Sales Manager"></asp:TextBox>
                            </div>

                            <!-- Mobile -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Mobile Number <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPhone" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPhone" runat="server" ControlToValidate="TxtPhone" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Alternate Phone -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-muted">Alternate Phone</label>
                                <asp:TextBox ID="TxtAltPhone" runat="server" CssClass="form-control" placeholder="e.g. 9876543211"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Email -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Email Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtEmail" runat="server" CssClass="form-control" placeholder="e.g. supplier@domain.com" TextMode="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqEmail" runat="server" ControlToValidate="TxtEmail" 
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
                                <asp:TextBox ID="TxtAddress" runat="server" CssClass="form-control" placeholder="e.g. 123 Industrial Area"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqAddress" runat="server" ControlToValidate="TxtAddress" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SupplierForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- City -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">City <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtCity" runat="server" CssClass="form-control" placeholder="e.g. Udaipur"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqCity" runat="server" ControlToValidate="TxtCity" 
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
                                <asp:TextBox ID="TxtGst" runat="server" CssClass="form-control" placeholder="e.g. 08AAAAA0000A1Z2"></asp:TextBox>
                            </div>

                            <!-- PAN Number -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">PAN Number</label>
                                <asp:TextBox ID="TxtPan" runat="server" CssClass="form-control" placeholder="e.g. ABCDE1234F"></asp:TextBox>
                            </div>

                            <!-- Status -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Status <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DdlStatus" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <!-- Password -->
                            <div class="col-md-3 mb-3">
                                <label class="form-label fw-semibold text-muted">Portal Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPassword" runat="server" CssClass="form-control" placeholder="Enter password" Required="true"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Bank Details -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Bank Details (Optional)</label>
                            <asp:TextBox ID="TxtBank" runat="server" CssClass="form-control" placeholder="e.g. Bank Name, A/C: 123456789, IFSC: SBIN0000123" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        </div>

                        <div class="row">
                            <!-- Logo/Photo -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Change Logo / Photo</label>
                                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="form-control" />
                            </div>

                            <!-- Current Photo Preview -->
                            <div class="col-md-6 mb-3 text-center text-md-start" id="PhotoDiv" runat="server">
                                <label class="form-label fw-semibold text-muted d-block">Current Logo / Photo</label>
                                <asp:Image ID="ImgPreview" runat="server" CssClass="current-photo-preview shadow-sm" />
                            </div>
                        </div>

                        <div class="d-flex gap-2 mt-3">
                            <asp:Button ID="BtnSave" runat="server" Text="Save Changes" CssClass="btn btn-primary px-4 py-2" ValidationGroup="SupplierForm" OnClick="BtnSave_Click" />
                            <a href="supplierlist.aspx" class="btn btn-outline-secondary px-4 py-2">Cancel</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
