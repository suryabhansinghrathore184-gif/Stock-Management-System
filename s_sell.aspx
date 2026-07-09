<%@ Page Title="My Supplies" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_sell.aspx.cs" Inherits="StockMangementSystem.WebForm16" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .supplies-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
        }
        .stat-badge {
            border-radius: 10px;
            border-left: 4px solid #10b981;
        }
        .info-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #64748b;
            display: block;
        }
        .info-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #0f172a;
            display: block;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">My Supply Logs</h3>
            <p class="text-muted small">View your supplied stock shipments and invoices</p>
        </div>

        <!-- Latest Supply Showcase (If any exist) -->
        <asp:Panel ID="LatestSupplyPanel" runat="server" CssClass="card stat-badge shadow-sm p-4 bg-white border-0 mb-4">
            <h6 class="fw-bold text-muted mb-3 text-uppercase"><i class="fa-solid fa-star text-warning me-2"></i>Most Recent Supply</h6>
            <div class="row g-3">
                <div class="col-sm-3">
                    <span class="info-label">Account ID</span>
                    <span class="info-value"><asp:Label ID="Label1" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-3">
                    <span class="info-label">Product Name</span>
                    <span class="info-value"><asp:Label ID="Label2" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-2">
                    <span class="info-label">Quantity Supplied</span>
                    <span class="info-value"><asp:Label ID="Label3" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-2">
                    <span class="info-label">Unit Cost</span>
                    <span class="info-value text-success">$<asp:Label ID="Label4" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-2">
                    <span class="info-label">Supply Date</span>
                    <span class="info-value"><asp:Label ID="Label5" runat="server"></asp:Label></span>
                </div>
            </div>
        </asp:Panel>

        <!-- Supplies Table Grid -->
        <div class="card supplies-card">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-truck-ramp-box me-2 text-success"></i>Supply Shipments Registry</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="GridView1_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="SupplierId" HeaderText="Supplier ID" />
                            <asp:BoundField DataField="ProductName" HeaderText="Item Supplied" />
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                            
                            <!-- Unit Price -->
                            <asp:TemplateField HeaderText="Unit Price ($)">
                                <ItemTemplate>
                                    <%# Convert.ToDecimal(Eval("PurchasePrice")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Total Value -->
                            <asp:TemplateField HeaderText="Total Cost ($)">
                                <ItemTemplate>
                                    <%# (Convert.ToDecimal(Eval("PurchasePrice")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Date -->
                            <asp:TemplateField HeaderText="Supply Date">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("PurchaseDate")).ToString("dd-MM-yyyy HH:mm") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-truck-field fs-2 mb-2 d-block"></i>
                                No supplies recorded yet.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
