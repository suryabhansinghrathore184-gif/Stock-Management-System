<%@ Page Title="My Orders" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_purcahse.aspx.cs" Inherits="StockMangementSystem.WebForm12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .orders-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
        }
        .stat-badge {
            border-radius: 10px;
            border-left: 4px solid #0ea5e9;
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
            <h3 class="fw-bold mb-0 text-dark">My Purchase Orders</h3>
            <p class="text-muted small">View your recent purchases and invoice history</p>
        </div>

        <!-- Latest Order Showcase (If any exist) -->
        <asp:Panel ID="LatestOrderPanel" runat="server" CssClass="card stat-badge shadow-sm p-4 bg-white border-0 mb-4">
            <h6 class="fw-bold text-muted mb-3 text-uppercase"><i class="fa-solid fa-star me-2 text-warning"></i>Most Recent Order</h6>
            <div class="row g-3">
                <div class="col-sm-3">
                    <span class="info-label">Customer ID</span>
                    <span class="info-value"><asp:Label ID="Label1" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-3">
                    <span class="info-label">Product Name</span>
                    <span class="info-value"><asp:Label ID="Label2" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-2">
                    <span class="info-label">Quantity</span>
                    <span class="info-value"><asp:Label ID="Label3" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-2">
                    <span class="info-label">Total Cost</span>
                    <span class="info-value text-success">$<asp:Label ID="Label4" runat="server"></asp:Label></span>
                </div>
                <div class="col-sm-2">
                    <span class="info-label">Order Date</span>
                    <span class="info-value"><asp:Label ID="Label6" runat="server"></asp:Label></span>
                </div>
            </div>
        </asp:Panel>

        <!-- Orders Table Grid -->
        <div class="card orders-card">
            <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-receipt me-2 text-primary"></i>All Orders Log</h5>
                <div class="d-flex align-items-center gap-2">
                    <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control form-control-sm" Placeholder="Invoice or Product..."></asp:TextBox>
                    <asp:Button ID="BtnSearch" runat="server" CssClass="btn btn-sm btn-primary" Text="Search" OnClick="BtnSearch_Click" />
                    <asp:Button ID="BtnClear" runat="server" CssClass="btn btn-sm btn-secondary" Text="Clear" OnClick="BtnClear_Click" />
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="GridView1_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice No" />
                            <asp:BoundField DataField="ProductName" HeaderText="Item Name" />
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                            
                            <%-- Total Price --%>
                            <asp:TemplateField HeaderText="Total Price ($)">
                                <ItemTemplate>
                                    <%# Convert.ToDecimal(Eval("Total")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- Date --%>
                            <asp:TemplateField HeaderText="Purchase Date">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("SaleDate")).ToString("dd-MM-yyyy HH:mm") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- Actions --%>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <a href='print_invoice.aspx?invoice=<%# Eval("InvoiceNumber") %>' target="_blank" class="btn btn-sm btn-outline-primary py-1 px-2.5">
                                        <i class="fa-solid fa-print me-1.5"></i>Print / PDF
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-receipt fs-2 mb-2 d-block"></i>
                                No matching orders found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
