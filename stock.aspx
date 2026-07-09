<%@ Page Title="Inventory & Stock Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="stock.aspx.cs" Inherits="StockMangementSystem.stock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stock-badge {
            font-size: 0.85rem;
            padding: 5px 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Inventory & Stock</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Inventory</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Alert Cards -->
        <div class="row mb-4">
            <div class="col-md-4 mb-3">
                <div class="card bg-success-subtle text-success border-0 rounded-3 p-3">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-muted small fw-semibold uppercase">Healthy Stock Items</span>
                            <h3 class="fw-bold m-0 mt-1"><asp:Label ID="LblHealthyCount" runat="server" Text="0"></asp:Label></h3>
                        </div>
                        <i class="fa-solid fa-square-check fs-2 opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card bg-warning-subtle text-warning border-0 rounded-3 p-3">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-muted small fw-semibold uppercase">Low Stock Alerts</span>
                            <h3 class="fw-bold m-0 mt-1"><asp:Label ID="LblLowStockCount" runat="server" Text="0"></asp:Label></h3>
                        </div>
                        <i class="fa-solid fa-triangle-exclamation fs-2 opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card bg-danger-subtle text-danger border-0 rounded-3 p-3">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="d-block text-muted small fw-semibold uppercase">Out of Stock Items</span>
                            <h3 class="fw-bold m-0 mt-1"><asp:Label ID="LblOutOfStockCount" runat="server" Text="0"></asp:Label></h3>
                        </div>
                        <i class="fa-solid fa-circle-xmark fs-2 opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Manual Stock Adjustment Form -->
            <div class="col-lg-4 mb-4">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-sliders me-2 text-primary"></i>Stock Adjustment</h5>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <!-- Product selection -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Product <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="DdlProduct" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="DdlProduct_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="ReqProduct" runat="server" ControlToValidate="DdlProduct" InitialValue=""
                                ErrorMessage="Please select a product" CssClass="text-danger small d-block mt-1" ValidationGroup="AdjustmentForm"></asp:RequiredFieldValidator>
                            <asp:Label ID="CurrentStockLabel" runat="server" CssClass="text-muted small d-block mt-1"></asp:Label>
                        </div>

                        <!-- Adjustment Type -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Adjustment Type <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="DdlAdjType" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Addition">Increase Stock (+)</asp:ListItem>
                                <asp:ListItem Value="Deduction">Decrease Stock (-)</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Quantity -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Adjustment Qty <span class="text-danger">*</span></label>
                            <asp:TextBox ID="TxtQuantity" runat="server" CssClass="form-control" placeholder="e.g. 10"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ReqQty" runat="server" ControlToValidate="TxtQuantity" 
                                ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="AdjustmentForm"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="ValQty" runat="server" ControlToValidate="TxtQuantity" Type="Integer" Operator="DataTypeCheck"
                                ErrorMessage="Invalid integer" CssClass="text-danger small d-block mt-1" ValidationGroup="AdjustmentForm"></asp:CompareValidator>
                        </div>

                        <!-- Remarks -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted">Remarks / Reason <span class="text-danger">*</span></label>
                            <asp:TextBox ID="TxtRemarks" runat="server" CssClass="form-control" placeholder="e.g. Damaged inventory / Audit correction" Required="true"></asp:TextBox>
                        </div>

                        <asp:Button ID="BtnSave" runat="server" Text="Apply Adjustment" CssClass="btn btn-primary w-100" ValidationGroup="AdjustmentForm" OnClick="BtnSave_Click" />
                    </div>
                </div>
            </div>

            <!-- Current Stock Table -->
            <div class="col-lg-8 mb-4">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <ul class="nav nav-tabs border-bottom-0" id="stockTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active fw-bold text-uppercase py-2.5" id="stock-list-tab" data-bs-toggle="tab" data-bs-target="#stock-list" type="button" role="tab" aria-selected="true">Current Stock</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link fw-bold text-uppercase py-2.5" id="stock-history-tab" data-bs-toggle="tab" data-bs-target="#stock-history" type="button" role="tab" aria-selected="false">Audit Logs / History</button>
                            </li>
                        </ul>

                        <div class="d-flex gap-2">
                            <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control form-control-sm" placeholder="Search..." OnTextChanged="TxtSearch_TextChanged" AutoPostBack="true" style="width: 180px;"></asp:TextBox>
                            <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClick="BtnReset_Click"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <div class="tab-content" id="stockTabsContent">
                            <!-- Stock Directory Tab -->
                            <div class="tab-pane fade show active" id="stock-list" role="tabpanel" aria-labelledby="stock-list-tab">
                                <div class="table-responsive">
                                    <asp:GridView ID="GridStock" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductCode"
                                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                        AllowPaging="True" PageSize="5" OnPageIndexChanging="GridStock_PageIndexChanging">
                                        <Columns>
                                            <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                                            <asp:BoundField DataField="ProductName" HeaderText="Item Name" />
                                            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                                            <asp:BoundField DataField="Quantity" HeaderText="Stock Level" />
                                            <asp:TemplateField HeaderText="Status">
                                                <ItemTemplate>
                                                    <span class='badge <%# Convert.ToInt32(Eval("Quantity")) == 0 ? "bg-danger" : (Convert.ToInt32(Eval("Quantity")) <= 10 ? "bg-warning text-dark" : "bg-success") %> stock-badge rounded-pill'>
                                                        <%# Convert.ToInt32(Eval("Quantity")) == 0 ? "Out of Stock" : (Convert.ToInt32(Eval("Quantity")) <= 10 ? "Low Stock" : "Healthy") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <PagerStyle CssClass="pagination-container" />
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-muted">No stock data available.</div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>

                            <!-- Audit Logs Tab -->
                            <div class="tab-pane fade" id="stock-history" role="tabpanel" aria-labelledby="stock-history-tab">
                                <div class="table-responsive">
                                    <asp:GridView ID="GridHistory" runat="server" AutoGenerateColumns="False" DataKeyNames="HistoryId"
                                        CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                        AllowPaging="True" PageSize="5" OnPageIndexChanging="GridHistory_PageIndexChanging">
                                        <Columns>
                                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                            <asp:TemplateField HeaderText="Type">
                                                <ItemTemplate>
                                                    <span class='badge <%# Eval("ChangeType").ToString() == "Purchase" ? "bg-primary" : (Eval("ChangeType").ToString() == "Sale" ? "bg-success" : "bg-secondary") %> px-2 py-1'>
                                                        <%# Eval("ChangeType") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Qty Shift">
                                                <ItemTemplate>
                                                    <span class='fw-bold <%# Convert.ToInt32(Eval("Quantity")) >= 0 ? "text-success" : "text-danger" %>'>
                                                        <%# (Convert.ToInt32(Eval("Quantity")) >= 0 ? "+" : "") + Eval("Quantity") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Remarks" HeaderText="Remarks" NullDisplayText="-" />
                                            <asp:BoundField DataField="ChangeDate" HeaderText="Timestamp" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                                        </Columns>
                                        <PagerStyle CssClass="pagination-container" />
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-muted">No transaction logs available.</div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
