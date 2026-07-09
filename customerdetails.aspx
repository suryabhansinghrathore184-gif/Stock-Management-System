<%@ Page Title="Customer Details" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="customerdetails.aspx.cs" Inherits="StockMangementSystem.customerdetails" %>
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
                <h3 class="fw-bold mb-0 text-dark">Customer Profile Details</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="customerlist.aspx">Customers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Customer Details</li>
                    </ol>
                </nav>
            </div>
            <div class="d-flex gap-2">
                <asp:HyperLink ID="LnkEdit" runat="server" CssClass="btn btn-outline-primary btn-sm"><i class="fa-solid fa-user-pen me-1.5"></i>Edit Customer</asp:HyperLink>
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
                        <span class="badge bg-primary rounded-pill px-3 py-1.5 mb-2"><asp:Label ID="LblType" runat="server"></asp:Label></span>
                        <div class="d-block mt-2">
                            <span class='badge <%# LblStatus.Text == "Active" ? "bg-success" : "bg-danger" %> rounded-pill px-2 py-1'>
                                <asp:Label ID="LblStatus" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="card card-premium mt-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h6 class="fw-bold m-0 text-uppercase text-muted"><i class="fa-solid fa-address-book me-2"></i>Contact Details</h6>
                    </div>
                    <div class="card-body">
                        <span class="info-label">Customer ID</span>
                        <span class="info-value"><asp:Label ID="LblId" runat="server"></asp:Label></span>

                        <span class="info-label">Company Name</span>
                        <span class="info-value"><asp:Label ID="LblCompany" runat="server" Text="-"></asp:Label></span>

                        <span class="info-label">Mobile Number</span>
                        <span class="info-value"><asp:Label ID="LblPhone" runat="server"></asp:Label></span>

                        <span class="info-label">Alternate Mobile</span>
                        <span class="info-value"><asp:Label ID="LblAltPhone" runat="server" Text="-"></asp:Label></span>

                        <span class="info-label">Email Address</span>
                        <span class="info-value"><asp:Label ID="LblEmail" runat="server"></asp:Label></span>

                        <span class="info-label">GSTIN / Tax ID</span>
                        <span class="info-value"><asp:Label ID="LblGst" runat="server" Text="N/A"></asp:Label></span>

                        <span class="info-label">Full Address</span>
                        <span class="info-value">
                            <asp:Label ID="LblAddress" runat="server"></asp:Label>, 
                            <asp:Label ID="LblCity" runat="server"></asp:Label>, 
                            <asp:Label ID="LblState" runat="server"></asp:Label> - 
                            <asp:Label ID="LblPostal" runat="server"></asp:Label>, 
                            <asp:Label ID="LblCountry" runat="server"></asp:Label>
                        </span>

                        <span class="info-label">Date Registered</span>
                        <span class="info-value"><asp:Label ID="LblCreatedDate" runat="server"></asp:Label></span>
                    </div>
                </div>
            </div>

            <!-- Right History & Stats Column -->
            <div class="col-lg-8 mb-4">
                <!-- Stats row -->
                <div class="row mb-4">
                    <!-- Total Orders -->
                    <div class="col-sm-6 mb-3">
                        <div class="card stat-card shadow-sm p-3 bg-white border-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="info-label text-muted">Total Billing Invoices</span>
                                    <h3 class="fw-bold m-0 mt-1"><asp:Label ID="LblTotalOrders" runat="server" Text="0"></asp:Label></h3>
                                </div>
                                <div class="bg-primary-subtle text-primary p-2.5 rounded-3"><i class="fa-solid fa-file-invoice fs-4"></i></div>
                            </div>
                        </div>
                    </div>

                    <!-- Total spent -->
                    <div class="col-sm-6 mb-3">
                        <div class="card stat-card shadow-sm p-3 bg-white border-0" style="border-left-color: #10b981;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="info-label text-muted">Total Amount Spent</span>
                                    <h3 class="fw-bold m-0 mt-1 text-success">$<asp:Label ID="LblTotalSpent" runat="server" Text="0.00"></asp:Label></h3>
                                </div>
                                <div class="bg-success-subtle text-success p-2.5 rounded-3"><i class="fa-solid fa-hand-holding-dollar fs-4"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Transaction Log -->
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>Customer Billing History</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="GridHistory" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                AllowPaging="True" PageSize="5" OnPageIndexChanging="GridHistory_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Item" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                    <asp:BoundField DataField="SellingPrice" HeaderText="Price ($)" DataFormatString="{0:N2}" />
                                    <asp:BoundField DataField="Discount" HeaderText="Disc ($)" DataFormatString="{0:N2}" />
                                    <asp:BoundField DataField="Total" HeaderText="Total ($)" DataFormatString="{0:N2}" />
                                    <asp:BoundField DataField="SaleDate" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                                </Columns>
                                <PagerStyle CssClass="pagination-container" />
                                <EmptyDataTemplate>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fa-solid fa-receipt fs-2 mb-2 d-block"></i>
                                        No billing transactions found for this customer.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
