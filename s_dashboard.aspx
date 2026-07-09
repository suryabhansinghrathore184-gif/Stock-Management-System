<%@ Page Title="Supplier Dashboard" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_dashboard.aspx.cs" Inherits="StockMangementSystem.s_dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard-stat-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .dashboard-stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0,0,0,0.1);
        }
        .quick-action-card {
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        .quick-action-card:hover {
            background-color: var(--primary-color) !important;
            color: white !important;
            transform: translateY(-3px);
        }
        .quick-action-card:hover i {
            color: white !important;
        }
    </style>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Welcome, <asp:Label ID="LblSupplierName" runat="server" Text="Supplier"></asp:Label></h3>
            <p class="text-muted small">Here is a quick overview of your business activity and shipments</p>
        </div>

        <!-- Stats Grid -->
        <div class="row mb-4">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Supplied Products</span>
                            <h2 class="fw-bold mb-0 text-dark mt-1"><asp:Label ID="LblTotalProducts" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <div class="bg-primary-subtle text-primary p-3 rounded-3">
                            <i class="fa-solid fa-boxes-packing fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Total Revenue</span>
                            <h2 class="fw-bold mb-0 text-success mt-1">$<asp:Label ID="LblRevenue" runat="server" Text="0.00"></asp:Label></h2>
                        </div>
                        <div class="bg-success-subtle text-success p-3 rounded-3">
                            <i class="fa-solid fa-file-invoice-dollar fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Pending Shipments</span>
                            <h2 class="fw-bold mb-0 text-warning mt-1"><asp:Label ID="LblPendingShipments" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <div class="bg-warning-subtle text-warning p-3 rounded-3">
                            <i class="fa-solid fa-truck-fast fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Completed Shipments</span>
                            <h2 class="fw-bold mb-0 text-info mt-1"><asp:Label ID="LblCompletedShipments" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <div class="bg-info-subtle text-info p-3 rounded-3">
                            <i class="fa-solid fa-circle-check fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <h5 class="fw-bold mb-3 text-dark">Quick Actions</h5>
        <div class="row mb-4">
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="s_profile.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-id-card fs-2 text-primary mb-2"></i>
                    <span class="fw-bold text-dark">My Profile</span>
                </a>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="s_products.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-boxes-stacked fs-2 text-success mb-2"></i>
                    <span class="fw-bold text-dark">My Products</span>
                </a>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="s_deliveryschedule.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-calendar-days fs-2 text-danger mb-2"></i>
                    <span class="fw-bold text-dark">Delivery Schedule</span>
                </a>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="s_documents.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-folder-open fs-2 text-warning mb-2"></i>
                    <span class="fw-bold text-dark">Business Documents</span>
                </a>
            </div>
        </div>

        <!-- Charts and Recent Activity -->
        <div class="row">
            <div class="col-lg-6 mb-4">
                <div class="card border-0 shadow-sm p-4 bg-white" style="border-radius: 12px;">
                    <h5 class="fw-bold mb-3 text-dark">Supply Shipments Split</h5>
                    <canvas id="shipmentsChart" style="max-height: 250px;"></canvas>
                </div>
            </div>
            <div class="col-lg-6 mb-4">
                <div class="card border-0 shadow-sm p-4 bg-white" style="border-radius: 12px; min-height: 312px;">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold m-0 text-dark">Recent Supplies</h5>
                        <a href="s_sell.aspx" class="btn btn-sm btn-link text-success p-0">View All</a>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="GvRecentSupplies" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="PurchaseId" HeaderText="PO ID" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                <asp:TemplateField HeaderText="Total Value">
                                    <ItemTemplate>
                                        $<%# (Convert.ToDecimal(Eval("PurchasePrice")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delivery Status">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("DeliveryStatus").ToString() == "Delivered" ? "bg-success" : (Eval("DeliveryStatus").ToString() == "In Transit" ? "bg-info" : "bg-warning") %>'>
                                            <%# Eval("DeliveryStatus") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-4 text-muted">
                                    No recent supplies found.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart rendering JavaScript -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var ctx = document.getElementById('shipmentsChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Delivered', 'Pending / In Transit'],
                    datasets: [{
                        data: [<%= DeliveredCount %>, <%= PendingCount %>],
                        backgroundColor: ['#10b981', '#f59e0b'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
