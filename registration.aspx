<%@ Page Title="User Registrations" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="registration.aspx.cs" Inherits="StockMangementSystem.WebForm18" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .registration-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">User Registrations</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Users</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Directory Table -->
        <div class="card card-premium registration-card">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-users-gear me-2 text-primary"></i>System Registrations Overview</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="True"
                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                        OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-users-slash fs-2 mb-2 d-block"></i>
                                No active registrations found in the system.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
