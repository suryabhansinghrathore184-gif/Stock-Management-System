<%@ Page Title="Transaction Audit" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="view.aspx.cs" Inherits="StockMangementSystem.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .audit-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .btn-group-toggle .btn {
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 600;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Transaction Log</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Audit Records</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Filter Card -->
        <div class="card card-premium mb-4">
            <div class="card-body d-flex flex-wrap align-items-center justify-content-between gap-3">
                <span class="text-muted fw-semibold">Select Transaction Filter:</span>
                
                <div class="btn-group" role="group">
                    <asp:RadioButton ID="RadioButton1" runat="server" GroupName="TxFilter" AutoPostBack="true" OnCheckedChanged="RadioButton1_CheckedChanged" Checked="true" />
                    <label class="form-check-label fw-bold text-primary me-4 ms-2" for="<%= RadioButton1.ClientID %>"><i class="fa-solid fa-cart-shopping me-1.5"></i>Sales Logs</label>

                    <asp:RadioButton ID="RadioButton2" runat="server" GroupName="TxFilter" AutoPostBack="true" OnCheckedChanged="RadioButton2_CheckedChanged" />
                    <label class="form-check-label fw-bold text-success ms-2" for="<%= RadioButton2.ClientID %>"><i class="fa-solid fa-truck-ramp-box me-1.5"></i>Purchase Logs</label>
                </div>
            </div>
        </div>

        <!-- Audit Table -->
        <div class="card card-premium audit-card">
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="True"
                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                        OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-folder-minus fs-2 mb-2 d-block"></i>
                                No logs found for this filter.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
