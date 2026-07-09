<%@ Page Title="My Performance" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_performance.aspx.cs" Inherits="StockMangementSystem.s_performance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .perf-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
    </style>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Supplier Performance Dashboard</h3>
            <p class="text-muted small">Analyze your supply stats, product quality ratings, and fulfillment speed</p>
        </div>

        <!-- Performance Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm p-4 bg-white border-start border-4 border-info">
                    <span class="text-muted small fw-semibold text-uppercase">Total Deliveries</span>
                    <h3 class="fw-bold text-info mb-0 mt-1"><asp:Label ID="LblTotalDeliveries" runat="server" Text="0"></asp:Label></h3>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm p-4 bg-white border-start border-4 border-success">
                    <span class="text-muted small fw-semibold text-uppercase">On-Time Delivery Rate</span>
                    <h3 class="fw-bold text-success mb-0 mt-1"><asp:Label ID="LblOnTimeRate" runat="server" Text="96.5%"></asp:Label></h3>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm p-4 bg-white border-start border-4 border-warning">
                    <span class="text-muted small fw-semibold text-uppercase">Product Quality Rating</span>
                    <h3 class="fw-bold text-warning mb-0 mt-1"><asp:Label ID="LblQualityRating" runat="server" Text="4.8 / 5.0"></asp:Label></h3>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Left Card: Chart -->
            <div class="col-lg-7 mb-4">
                <div class="card perf-card p-4">
                    <h5 class="fw-bold mb-3 text-dark">Monthly Supply Volume</h5>
                    <canvas id="performanceChart" style="max-height: 280px;"></canvas>
                </div>
            </div>

            <!-- Right Card: Performance breakdown -->
            <div class="col-lg-5 mb-4">
                <div class="card perf-card p-4">
                    <h5 class="fw-bold mb-3 text-dark">Fulfillment Metrics</h5>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="small fw-semibold text-muted">Order Accuracy</span>
                            <span class="small fw-bold text-dark">99.2%</span>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-success" style="width: 99.2%;"></div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="small fw-semibold text-muted">Response Time</span>
                            <span class="small fw-bold text-dark">94.8%</span>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-info" style="width: 94.8%;"></div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="small fw-semibold text-muted">Compliance Rate</span>
                            <span class="small fw-bold text-dark">98.0%</span>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-primary" style="width: 98.0%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart rendering JavaScript -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var ctx = document.getElementById('performanceChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Fulfillment Deliveries Count',
                        data: [5, 7, 6, 8, 5, 9, 12, 10, 8, 9, <%= TotalDeliveriesCount %>, 0],
                        backgroundColor: '#10b981',
                        borderRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
