<%@ Page Title="Customer Dashboard" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_dashboard.aspx.cs" Inherits="StockMangementSystem.c_dashboard" %>
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
            <h3 class="fw-bold mb-0 text-dark">Welcome back, <asp:Label ID="LblCustomerName" runat="server" Text="Customer"></asp:Label></h3>
            <p class="text-muted small">Here is a quick overview of your account activity</p>
        </div>

        <!-- Stats Grid -->
        <div class="row mb-4">
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Total Orders</span>
                            <h2 class="fw-bold mb-0 text-dark mt-1"><asp:Label ID="LblTotalOrders" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <div class="bg-primary-subtle text-primary p-3 rounded-3">
                            <i class="fa-solid fa-cart-shopping fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Amount Spent</span>
                            <h2 class="fw-bold mb-0 text-success mt-1">$<asp:Label ID="LblAmountSpent" runat="server" Text="0.00"></asp:Label></h2>
                        </div>
                        <div class="bg-success-subtle text-success p-3 rounded-3">
                            <i class="fa-solid fa-wallet fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Pending Orders</span>
                            <h2 class="fw-bold mb-0 text-warning mt-1"><asp:Label ID="LblPendingOrders" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <div class="bg-warning-subtle text-warning p-3 rounded-3">
                            <i class="fa-solid fa-clock fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <div class="card dashboard-stat-card border-0 bg-white p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted small fw-semibold uppercase block">Completed Orders</span>
                            <h2 class="fw-bold mb-0 text-info mt-1"><asp:Label ID="LblCompletedOrders" runat="server" Text="0"></asp:Label></h2>
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
                <a href="c_profile.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-user-gear fs-2 text-primary mb-2"></i>
                    <span class="fw-bold text-dark">Edit Profile</span>
                </a>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="c_addressbook.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-address-book fs-2 text-success mb-2"></i>
                    <span class="fw-bold text-dark">Address Book</span>
                </a>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="c_wishlist.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-heart fs-2 text-danger mb-2"></i>
                    <span class="fw-bold text-dark">My Wishlist</span>
                </a>
            </div>
            <div class="col-md-3 col-sm-6 mb-3">
                <a href="c_support.aspx" class="card quick-action-card border-0 bg-white p-4 text-center">
                    <i class="fa-solid fa-circle-question fs-2 text-warning mb-2"></i>
                    <span class="fw-bold text-dark">Support Ticket</span>
                </a>
            </div>
        </div>

        <!-- Charts and Recent Activity -->
        <div class="row">
            <div class="col-lg-6 mb-4">
                <div class="card border-0 shadow-sm p-4 bg-white" style="border-radius: 12px;">
                    <h5 class="fw-bold mb-3 text-dark">Purchase Activity</h5>
                    <canvas id="purchaseChart" style="max-height: 250px;"></canvas>
                </div>
            </div>
            <div class="col-lg-6 mb-4">
                <div class="card border-0 shadow-sm p-4 bg-white" style="border-radius: 12px; min-height: 312px;">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold m-0 text-dark">Recent Invoices</h5>
                        <a href="c_purcahse.aspx" class="btn btn-sm btn-link text-primary p-0">View All</a>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="GvRecentOrders" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                <asp:TemplateField HeaderText="Total">
                                    <ItemTemplate>
                                        $<%# Convert.ToDecimal(Eval("Total")).ToString("N2") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("OrderStatus").ToString() == "Completed" ? "bg-success" : "bg-warning" %>'>
                                            <%# Eval("OrderStatus") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-4 text-muted">
                                    No recent invoices found.
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
            var ctx = document.getElementById('purchaseChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed Orders', 'Pending Orders'],
                    datasets: [{
                        data: [<%= CompletedCount %>, <%= PendingCount %>],
                        backgroundColor: ['#0ea5e9', '#f59e0b'],
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
