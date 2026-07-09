<%@ Page Title="Reporting Suite" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="reports.aspx.cs" Inherits="StockMangementSystem.reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .report-filters {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .main-content {
                margin: 0 !important;
                padding: 0 !important;
            }
            .invoice-card, .card {
                border: 0 !important;
                box-shadow: none !important;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Reporting Suite</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Reports</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Filter Card -->
        <div class="card card-premium report-filters mb-4 no-print">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-filter me-2 text-primary"></i>Report Configuration</h5>
            </div>
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <!-- Report Type -->
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted">Report Type</label>
                        <asp:DropDownList ID="DdlReportType" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="DdlReportType_SelectedIndexChanged">
                            <asp:ListItem Value="Product">Product Catalog & Value</asp:ListItem>
                            <asp:ListItem Value="Sales">Sales Transaction History</asp:ListItem>
                            <asp:ListItem Value="Purchase">Purchases Transaction History</asp:ListItem>
                            <asp:ListItem Value="Supplier">Supplier Directory</asp:ListItem>
                            <asp:ListItem Value="Customer">Customer Directory</asp:ListItem>
                            <asp:ListItem Value="Profit">Profit & Loss Summary</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Start Date -->
                    <div class="col-md-2" id="divStartDate" runat="server">
                        <label class="form-label fw-semibold text-muted">Start Date</label>
                        <asp:TextBox ID="TxtStartDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                    </div>

                    <!-- End Date -->
                    <div class="col-md-2" id="divEndDate" runat="server">
                        <label class="form-label fw-semibold text-muted">End Date</label>
                        <asp:TextBox ID="TxtEndDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                    </div>

                    <!-- Search Filter -->
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted">Search Keywords</label>
                        <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control form-control-sm" placeholder="e.g. Samsung, Active..."></asp:TextBox>
                    </div>

                    <!-- Action Buttons -->
                    <div class="col-md-2 d-flex gap-2">
                        <asp:Button ID="BtnGenerate" runat="server" Text="Filter" CssClass="btn btn-primary btn-sm w-100" OnClick="BtnGenerate_Click" />
                        <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="BtnReset_Click" ToolTip="Reset Filters"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Sheet Card -->
        <div class="card card-premium shadow-sm">
            <div class="card-header bg-white border-0 pt-4 pb-0 d-flex align-items-center justify-content-between">
                <h5 class="fw-bold m-0"><asp:Label ID="LblReportHeader" runat="server" Text="Product Report"></asp:Label></h5>
                
                <!-- Print/Export Actions -->
                <div class="d-flex gap-2 no-print">
                    <asp:LinkButton ID="BtnExportExcel" runat="server" CssClass="btn btn-success btn-sm" OnClick="BtnExportExcel_Click"><i class="fa-solid fa-file-excel me-1.5"></i>Export CSV</asp:LinkButton>
                    <button type="button" class="btn btn-primary btn-sm" onclick="window.print();"><i class="fa-solid fa-print me-1.5"></i>Print Sheet</button>
                </div>
            </div>
            
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GridReports" runat="server" AutoGenerateColumns="True"
                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="GridReports_PageIndexChanging">
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-regular fa-folder-open fs-2 mb-2 d-block"></i>
                                No matching records found for this report.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <!-- Summary Panel for Profit/Loss or Totals -->
                <asp:Panel ID="SummaryPanel" runat="server" Visible="false" CssClass="mt-4 p-3 bg-light rounded-3 border border-dashed text-end">
                    <asp:Label ID="SummaryTextLabel" runat="server" CssClass="fw-bold fs-5 text-dark"></asp:Label>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
