<%@ Page Title="Supplier Details" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="supplierdetails.aspx.cs" Inherits="StockMangementSystem.supplierdetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .details-avatar {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #e2e8f0;
        }
        .stat-card {
            border-radius: 10px;
            border-left: 4px solid #4f46e5;
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
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 no-print">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Supplier Profile Details</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="supplierlist.aspx">Suppliers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Supplier Details</li>
                    </ol>
                </nav>
            </div>
            <div class="d-flex gap-2">
                <asp:HyperLink ID="LnkEdit" runat="server" CssClass="btn btn-outline-primary btn-sm"><i class="fa-solid fa-user-pen me-1.5"></i>Edit Supplier</asp:HyperLink>
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="window.print();"><i class="fa-solid fa-print me-1.5"></i>Print Profile</button>
            </div>
        </div>

        <div class="row">
            <!-- Left Info Column -->
            <div class="col-lg-4 mb-4">
                <div class="card card-premium text-center">
                    <div class="card-body">
                        <asp:Image ID="ImgPhoto" runat="server" CssClass="details-avatar shadow-sm mb-3" />
                        <h4 class="fw-bold text-dark mb-1"><asp:Label ID="LblName" runat="server"></asp:Label></h4>
                        <span class="text-muted fw-semibold d-block mb-2"><i class="fa-solid fa-building me-1.5 text-primary"></i><asp:Label ID="LblCompany" runat="server"></asp:Label></span>
                        <div class="d-block mt-2">
                            <span class='badge <%# LblStatus.Text == "Active" ? "bg-success" : "bg-danger" %> rounded-pill px-2 py-1'>
                                <asp:Label ID="LblStatus" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="card card-premium mt-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h6 class="fw-bold m-0 text-uppercase text-muted"><i class="fa-solid fa-address-book me-2"></i>Contact & Biz Details</h6>
                    </div>
                    <div class="card-body">
                        <span class="info-label">Supplier ID</span>
                        <span class="info-value"><asp:Label ID="LblId" runat="server"></asp:Label></span>

                        <span class="info-label">Contact Person</span>
                        <span class="info-value"><asp:Label ID="LblContact" runat="server" Text="-"></asp:Label></span>

                        <span class="info-label">Mobile Number</span>
                        <span class="info-value"><asp:Label ID="LblPhone" runat="server"></asp:Label></span>

                        <span class="info-label">Alternate Phone</span>
                        <span class="info-value"><asp:Label ID="LblAltPhone" runat="server" Text="-"></asp:Label></span>

                        <span class="info-label">Email Address</span>
                        <span class="info-value"><asp:Label ID="LblEmail" runat="server"></asp:Label></span>

                        <span class="info-label">Website URL</span>
                        <span class="info-value"><asp:Label ID="LblWebsite" runat="server" Text="-"></asp:Label></span>

                        <span class="info-label">GSTIN / Tax ID</span>
                        <span class="info-value"><asp:Label ID="LblGst" runat="server" Text="N/A"></asp:Label></span>

                        <span class="info-label">PAN Number</span>
                        <span class="info-value"><asp:Label ID="LblPan" runat="server" Text="N/A"></asp:Label></span>

                        <span class="info-label">Full Address</span>
                        <span class="info-value">
                            <asp:Label ID="LblAddress" runat="server"></asp:Label>, 
                            <asp:Label ID="LblCity" runat="server"></asp:Label>, 
                            <asp:Label ID="LblState" runat="server"></asp:Label> - 
                            <asp:Label ID="LblPostal" runat="server"></asp:Label>, 
                            <asp:Label ID="LblCountry" runat="server"></asp:Label>
                        </span>

                        <span class="info-label">Bank Details</span>
                        <span class="info-value"><asp:Label ID="LblBank" runat="server" Text="-"></asp:Label></span>

                        <span class="info-label">Date Registered</span>
                        <span class="info-value"><asp:Label ID="LblCreatedDate" runat="server"></asp:Label></span>
                    </div>
                </div>
            </div>

            <!-- Right History & Stats Column -->
            <div class="col-lg-8 mb-4">
                <!-- Stats row -->
                <div class="row mb-4">
                    <!-- Total Purchases Count -->
                    <div class="col-sm-4 mb-3">
                        <div class="card stat-card shadow-sm p-3 bg-white border-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="info-label text-muted">Supply Shipments</span>
                                    <h3 class="fw-bold m-0 mt-1"><asp:Label ID="LblTotalPurchases" runat="server" Text="0"></asp:Label></h3>
                                </div>
                                <div class="bg-primary-subtle text-primary p-2.5 rounded-3"><i class="fa-solid fa-truck-ramp-box fs-4"></i></div>
                            </div>
                        </div>
                    </div>

                    <!-- Total Purchases Amount Spent -->
                    <div class="col-sm-4 mb-3">
                        <div class="card stat-card shadow-sm p-3 bg-white border-0" style="border-left-color: #10b981;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="info-label text-muted">Total Cost Paid</span>
                                    <h3 class="fw-bold m-0 mt-1 text-success">$<asp:Label ID="LblTotalSpent" runat="server" Text="0.00"></asp:Label></h3>
                                </div>
                                <div class="bg-success-subtle text-success p-2.5 rounded-3"><i class="fa-solid fa-hand-holding-dollar fs-4"></i></div>
                            </div>
                        </div>
                    </div>

                    <!-- Last Purchase Date -->
                    <div class="col-sm-4 mb-3">
                        <div class="card stat-card shadow-sm p-3 bg-white border-0" style="border-left-color: #f59e0b;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="info-label text-muted">Last Active Date</span>
                                    <h5 class="fw-bold m-0 mt-2"><asp:Label ID="LblLastPurchaseDate" runat="server" Text="-"></asp:Label></h5>
                                </div>
                                <div class="bg-warning-subtle text-warning p-2.5 rounded-3"><i class="fa-regular fa-calendar-check fs-4"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabs for supplied items and invoice history -->
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <ul class="nav nav-tabs border-bottom-0" id="supplierTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link fw-bold text-uppercase py-2.5" id="history-tab" data-bs-toggle="tab" data-bs-target="#history-list" type="button" role="tab" aria-selected="true">Supply Invoices</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link fw-bold text-uppercase py-2.5" id="products-tab" data-bs-toggle="tab" data-bs-target="#products-list" type="button" role="tab" aria-selected="false">Supplied Products</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link fw-bold text-uppercase py-2.5" id="docs-tab" data-bs-toggle="tab" data-bs-target="#docs-list" type="button" role="tab" aria-selected="false">Verification Docs & Bank</button>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="card-body">
                        <div class="tab-content" id="supplierTabsContent">
                            <!-- Invoice History Tab -->
                            <div class="tab-pane fade show active" id="history-list" role="tabpanel" aria-labelledby="history-tab">
                                <div class="table-responsive">
                                    <asp:GridView ID="GridHistory" runat="server" AutoGenerateColumns="False"
                                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                        AllowPaging="True" PageSize="5" OnPageIndexChanging="GridHistory_PageIndexChanging">
                                        <Columns>
                                            <asp:BoundField DataField="PurchaseId" HeaderText="Purchase ID" />
                                            <asp:BoundField DataField="ProductName" HeaderText="Item" />
                                            <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                            <asp:BoundField DataField="PurchasePrice" HeaderText="Cost ($)" DataFormatString="{0:N2}" />
                                            <asp:TemplateField HeaderText="Total Value ($)">
                                                <ItemTemplate>
                                                    <%# (Convert.ToDecimal(Eval("PurchasePrice")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="PurchaseDate" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                                        </Columns>
                                        <PagerStyle CssClass="pagination-container" />
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-muted">No supply shipments recorded yet.</div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>

                            <!-- Supplied Products Tab -->
                            <div class="tab-pane fade" id="products-list" role="tabpanel" aria-labelledby="products-tab">
                                <div class="table-responsive">
                                    <asp:GridView ID="GridProducts" runat="server" AutoGenerateColumns="False"
                                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                        AllowPaging="True" PageSize="5" OnPageIndexChanging="GridProducts_PageIndexChanging">
                                        <Columns>
                                            <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                                            <asp:BoundField DataField="ProductName" HeaderText="Item Name" />
                                            <asp:BoundField DataField="PurchasePrice" HeaderText="Cost Price ($)" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="SellingPrice" HeaderText="Selling Price ($)" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Quantity" HeaderText="In Stock" />
                                        </Columns>
                                        <PagerStyle CssClass="pagination-container" />
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-muted">No products registered under this supplier.</div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>

                            <!-- Verification Docs & Bank Tab -->
                            <div class="tab-pane fade" id="docs-list" role="tabpanel" aria-labelledby="docs-tab">
                                <div class="row mb-4">
                                    <div class="col-md-4 mb-3">
                                        <span class="info-label text-muted">Bank Name</span>
                                        <h6 class="fw-bold"><asp:Label ID="LblBankName" runat="server" Text="Not Configured"></asp:Label></h6>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <span class="info-label text-muted">Account Number</span>
                                        <h6 class="fw-bold"><asp:Label ID="LblBankAcc" runat="server" Text="Not Configured"></asp:Label></h6>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <span class="info-label text-muted">IFSC Code</span>
                                        <h6 class="fw-bold"><asp:Label ID="LblBankIfsc" runat="server" Text="Not Configured"></asp:Label></h6>
                                    </div>
                                </div>
                                <hr />
                                <h6 class="fw-bold text-uppercase text-muted mb-3"><i class="fa-solid fa-folder-open me-2"></i>Uploaded Documents</h6>
                                <div class="table-responsive">
                                    <asp:GridView ID="GridDocs" runat="server" AutoGenerateColumns="False"
                                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None">
                                        <Columns>
                                            <asp:BoundField DataField="DocumentType" HeaderText="Document Type" />
                                            <asp:TemplateField HeaderText="Upload Date">
                                                <ItemTemplate>
                                                    <%# Convert.ToDateTime(Eval("UploadedDate")).ToString("dd-MM-yyyy HH:mm") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Action">
                                                <ItemTemplate>
                                                    <a href='<%# "/Links/" + Eval("FilePath") %>' target="_blank" class="btn btn-xs btn-outline-primary">
                                                        <i class="fa-solid fa-download me-1"></i>View / Download
                                                    </a>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-muted">No business documents uploaded yet.</div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
