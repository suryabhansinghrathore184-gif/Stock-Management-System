<%@ Page Title="Customer Directory" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="customerlist.aspx.cs" Inherits="StockMangementSystem.WebForm6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .directory-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .customer-avatar {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
        }
        .btn-action-icon {
            padding: 4px 8px;
            font-size: 0.85rem;
            border-radius: 6px;
        }
        @media print {
            .no-print { display: none !important; }
            .card { border: 0 !important; box-shadow: none !important; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 no-print">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Customer Directory</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Customers</li>
                    </ol>
                </nav>
            </div>
            <div>
                <a href="newcustomer.aspx" class="btn btn-primary btn-sm"><i class="fa-solid fa-user-plus me-1.5"></i>Add Customer</a>
            </div>
        </div>

        <!-- Filter Panel -->
        <div class="card card-premium mb-4 no-print">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <!-- Search -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-muted">Search Customers</label>
                        <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control form-control-sm" placeholder="Search by name, email, phone..."></asp:TextBox>
                    </div>

                    <!-- Status Filter -->
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted">Filter by Status</label>
                        <asp:DropDownList ID="DdlStatus" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="All Statuses" Value=""></asp:ListItem>
                            <asp:ListItem Text="Active Only" Value="Active"></asp:ListItem>
                            <asp:ListItem Text="Inactive Only" Value="Inactive"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Sort Column -->
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted">Sort By</label>
                        <asp:DropDownList ID="DdlSort" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="Name (A-Z)" Value="name ASC"></asp:ListItem>
                            <asp:ListItem Text="Name (Z-A)" Value="name DESC"></asp:ListItem>
                            <asp:ListItem Text="Email" Value="email ASC"></asp:ListItem>
                            <asp:ListItem Text="Mobile" Value="number ASC"></asp:ListItem>
                            <asp:ListItem Text="Credit Limit" Value="CAST(creditlimit AS DECIMAL) DESC"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Buttons -->
                    <div class="col-md-2 d-flex gap-2">
                        <asp:Button ID="BtnApply" runat="server" Text="Apply" CssClass="btn btn-primary btn-sm w-100" OnClick="BtnApply_Click" />
                        <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="BtnReset_Click" ToolTip="Reset Filters"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <!-- Directory Table -->
        <div class="card card-premium directory-card">
            <div class="card-header bg-white border-0 pt-4 pb-0 d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-users me-2 text-primary"></i>Customers Registry</h5>
                <!-- Export/Print Actions -->
                <div class="d-flex gap-2 no-print">
                    <asp:LinkButton ID="BtnExportCSV" runat="server" CssClass="btn btn-success btn-sm" OnClick="BtnExportCSV_Click"><i class="fa-solid fa-file-csv me-1.5"></i>Export CSV</asp:LinkButton>
                    <button type="button" class="btn btn-primary btn-sm" onclick="window.print();"><i class="fa-solid fa-print me-1.5"></i>Print List</button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="GridView1_PageIndexChanging"
                        OnRowCommand="GridView1_RowCommand">
                        <Columns>
                            <!-- Avatar -->
                            <asp:TemplateField HeaderText="Photo">
                                <ItemTemplate>
                                    <img src='<%# string.IsNullOrEmpty(Eval("photolink").ToString()) ? "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=80&q=80" : "/Links/" + Eval("photolink") %>' class="customer-avatar shadow-sm border" alt="Avatar" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Id" HeaderText="ID" />
                            <asp:BoundField DataField="name" HeaderText="Full Name" />
                            <asp:BoundField DataField="email" HeaderText="Email Address" />
                            <asp:BoundField DataField="number" HeaderText="Mobile" />
                            <asp:BoundField DataField="city" HeaderText="City" />
                            <asp:BoundField DataField="customertype" HeaderText="Type" />
                            
                            <!-- Credit Limit -->
                            <asp:TemplateField HeaderText="Credit ($)">
                                <ItemTemplate>
                                    <%# Convert.ToDecimal(Eval("creditlimit")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Status Badge -->
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("status").ToString() == "Active" ? "bg-success" : "bg-danger" %> rounded-pill px-2.5 py-1.5'>
                                        <%# Eval("status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Actions -->
                            <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="no-print" HeaderStyle-CssClass="no-print">
                                <ItemTemplate>
                                    <!-- View Details -->
                                    <a href='customerdetails.aspx?id=<%# Eval("Id") %>' class="btn btn-outline-info btn-action-icon" title="View Details"><i class="fa-solid fa-eye"></i></a>
                                    <!-- Edit -->
                                    <a href='editcustomer.aspx?id=<%# Eval("Id") %>' class="btn btn-outline-primary btn-action-icon" title="Edit Profile"><i class="fa-solid fa-pen-to-square"></i></a>
                                    <!-- Toggle Status -->
                                    <asp:LinkButton ID="BtnToggle" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-outline-warning btn-action-icon" title="Activate/Deactivate"><i class="fa-solid fa-arrows-rotate"></i></asp:LinkButton>
                                    <!-- Delete -->
                                    <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteCustomer" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-outline-danger btn-action-icon" title="Delete" OnClientClick="return confirm('Are you sure you want to permanently delete this customer record?');"><i class="fa-solid fa-trash-can"></i></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-user-slash fs-2 mb-2 d-block"></i>
                                No customers registered or matching the filters.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
