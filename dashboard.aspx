<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="StockMangementSystem.dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .kpi-card {
            border-radius: 12px;
            border: 0;
            color: #fff;
            transition: transform 0.2s;
        }
        .kpi-card:hover {
            transform: translateY(-3px);
        }
        .bg-gradient-primary { background: linear-gradient(135deg, #4f46e5, #6366f1); }
        .bg-gradient-success { background: linear-gradient(135deg, #10b981, #34d399); }
        .bg-gradient-warning { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
        .bg-gradient-danger { background: linear-gradient(135deg, #ef4444, #f87171); }
        .bg-gradient-info { background: linear-gradient(135deg, #06b6d4, #22d3ee); }
        .bg-gradient-dark { background: linear-gradient(135deg, #1e293b, #475569); }
        
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
    </style>
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Page Title -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Business Dashboard</h3>
                <p class="text-muted small mb-0">Overview and real-time business statistics</p>
            </div>
            <div class="no-print">
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="window.print();">
                    <i class="fa-solid fa-print me-2"></i>Print Summary
                </button>
            </div>
        </div>

        <!-- KPI Grid -->
        <div class="row mb-4">
            <!-- Products -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card kpi-card bg-gradient-primary p-3 shadow-sm">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-white-50 small fw-semibold text-uppercase">Total Products</span>
                            <h2 class="fw-bold m-0 mt-1"><asp:Label ID="LblTotalProducts" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <i class="fa-solid fa-box fs-1 opacity-50"></i>
                    </div>
                </div>
            </div>

            <!-- Categories -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card kpi-card bg-gradient-info p-3 shadow-sm">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-white-50 small fw-semibold text-uppercase">Categories</span>
                            <h2 class="fw-bold m-0 mt-1"><asp:Label ID="LblTotalCategories" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <i class="fa-solid fa-tags fs-1 opacity-50"></i>
                    </div>
                </div>
            </div>

            <!-- Customers -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card kpi-card bg-gradient-success p-3 shadow-sm">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-white-50 small fw-semibold text-uppercase">Active Customers</span>
                            <h2 class="fw-bold m-0 mt-1"><asp:Label ID="LblTotalCustomers" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <i class="fa-solid fa-users fs-1 opacity-50"></i>
                    </div>
                </div>
            </div>

            <!-- Suppliers -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card kpi-card bg-gradient-dark p-3 shadow-sm">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-white-50 small fw-semibold text-uppercase">Active Suppliers</span>
                            <h2 class="fw-bold m-0 mt-1"><asp:Label ID="LblTotalSuppliers" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <i class="fa-solid fa-truck-field fs-1 opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <!-- Today's Sales -->
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm p-3 bg-white d-flex flex-row align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small fw-semibold text-uppercase">Today's Sales</span>
                        <h4 class="fw-bold text-success m-0 mt-1">$<asp:Label ID="LblTodaySales" runat="server" Text="0.00"></asp:Label></h4>
                    </div>
                    <div class="bg-success-subtle text-success p-3 rounded-circle"><i class="fa-solid fa-hand-holding-dollar fs-4"></i></div>
                </div>
            </div>
            <!-- Monthly Sales -->
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm p-3 bg-white d-flex flex-row align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small fw-semibold text-uppercase">Monthly Sales</span>
                        <h4 class="fw-bold text-primary m-0 mt-1">$<asp:Label ID="LblMonthlySales" runat="server" Text="0.00"></asp:Label></h4>
                    </div>
                    <div class="bg-primary-subtle text-primary p-3 rounded-circle"><i class="fa-solid fa-calendar-check fs-4"></i></div>
                </div>
            </div>
            <!-- Low Stock Warnings -->
            <div class="col-md-4 mb-3">
                <a href="stock.aspx" class="text-decoration-none">
                    <div class="card border-0 shadow-sm p-3 bg-white d-flex flex-row align-items-center justify-content-between">
                        <div>
                            <span class="text-danger small fw-semibold text-uppercase">Low Stock Warnings</span>
                            <h4 class="fw-bold text-danger m-0 mt-1"><asp:Label ID="LblLowStockCount" runat="server" Text="0"></asp:Label></h4>
                        </div>
                        <div class="bg-danger-subtle text-danger p-3 rounded-circle"><i class="fa-solid fa-triangle-exclamation fs-4"></i></div>
                    </div>
                </a>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row mb-4">
            <!-- Sales & Purchase Trends -->
            <div class="col-lg-8 mb-4">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-chart-line me-2 text-primary"></i>Sales & Purchases Trends</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="trendChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Stock Distribution -->
            <div class="col-lg-4 mb-4">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-chart-pie me-2 text-primary"></i>Stock Status</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="stockPieChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Transactions -->
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0 d-flex align-items-center justify-content-between">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-list-check me-2 text-primary"></i>Recent Transactions (Sales)</h5>
                        <a href="view.aspx" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="GridRecentSales" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-hover table-premium align-middle mb-0" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice No" />
                                    <asp:BoundField DataField="customername" HeaderText="Customer" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Item Name" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                    <asp:BoundField DataField="Total" HeaderText="Total Value ($)" DataFormatString="{0:N2}" />
                                    <asp:BoundField DataField="SaleDate" HeaderText="Sale Date" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="text-center py-4 text-muted">No recent sales transactions recorded.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Script to render Chart.js charts -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Trend Line/Bar Chart
            var ctxTrend = document.getElementById('trendChart').getContext('2d');
            var trendChart = new Chart(ctxTrend, {
                type: 'line',
                data: {
                    labels: <%= GetMonthlyLabelsJson() %>,
                    datasets: [
                        {
                            label: 'Sales ($)',
                            data: <%= GetMonthlySalesDataJson() %>,
                            borderColor: '#10b981',
                            backgroundColor: 'rgba(16, 185, 129, 0.1)',
                            borderWidth: 3,
                            tension: 0.3,
                            fill: true
                        },
                        {
                            label: 'Purchases ($)',
                            data: <%= GetMonthlyPurchasesDataJson() %>,
                            borderColor: '#4f46e5',
                            backgroundColor: 'rgba(79, 70, 229, 0.1)',
                            borderWidth: 3,
                            tension: 0.3,
                            fill: true
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: '#f1f5f9' }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });

            // Stock Pie Chart
            var ctxPie = document.getElementById('stockPieChart').getContext('2d');
            var stockPieChart = new Chart(ctxPie, {
                type: 'doughnut',
                data: {
                    labels: ['Healthy Stock', 'Low Stock', 'Out of Stock'],
                    datasets: [{
                        data: [
                            <%= LblHealthyCountHidden %>,
                            <%= LblLowStockCountHidden %>,
                            <%= LblOutOfStockCountHidden %>
                        ],
                        backgroundColor: ['#10b981', '#f59e0b', '#ef4444'],
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    },
                    cutout: '65%'
                }
            });
        });
    </script>
</asp:Content>
