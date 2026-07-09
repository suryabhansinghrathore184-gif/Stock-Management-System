<%@ Page Title="Purchase Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="purchase.aspx.cs" Inherits="StockMangementSystem.WebForm7" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .purchase-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Purchase Management</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Purchases</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <!-- Purchase Form -->
            <div class="col-lg-4 mb-4">
                <div class="card card-premium purchase-card">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-cart-plus me-2 text-primary"></i>Record Purchase</h5>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <!-- Supplier -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Supplier <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="DdlSupplier" runat="server" CssClass="form-select"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="ReqSupplier" runat="server" ControlToValidate="DdlSupplier" InitialValue=""
                                ErrorMessage="Please select a supplier" CssClass="text-danger small d-block mt-1" ValidationGroup="PurchaseForm"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Product -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Product <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="DdlProduct" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="DdlProduct_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="ReqProduct" runat="server" ControlToValidate="DdlProduct" InitialValue=""
                                ErrorMessage="Please select a product" CssClass="text-danger small d-block mt-1" ValidationGroup="PurchaseForm"></asp:RequiredFieldValidator>
                        </div>

                        <div class="row">
                            <!-- Purchase Price -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Purchase Cost ($) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPrice" runat="server" ControlToValidate="TxtPrice" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="PurchaseForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValPrice" runat="server" ControlToValidate="TxtPrice" Type="Double" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid cost" CssClass="text-danger small d-block mt-1" ValidationGroup="PurchaseForm"></asp:CompareValidator>
                            </div>
                            <!-- Quantity -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Quantity <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtQuantity" runat="server" CssClass="form-control" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqQty" runat="server" ControlToValidate="TxtQuantity" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="PurchaseForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValQty" runat="server" ControlToValidate="TxtQuantity" Type="Integer" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid integer" CssClass="text-danger small d-block mt-1" ValidationGroup="PurchaseForm"></asp:CompareValidator>
                            </div>
                        </div>

                        <!-- Purchase Date -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted">Purchase Date</label>
                            <asp:TextBox ID="TxtDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>

                        <asp:Button ID="BtnSave" runat="server" Text="Save Purchase" CssClass="btn btn-primary w-100" ValidationGroup="PurchaseForm" OnClick="BtnSave_Click" />
                    </div>
                </div>
            </div>

            <!-- Purchase History Grid -->
            <div class="col-lg-8 mb-4">
                <div class="card card-premium h-100">
                    <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-list-check me-2 text-primary"></i>Purchase Records</h5>
                        <div class="d-flex gap-2">
                            <div class="input-group input-group-sm" style="width: 240px;">
                                <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control" placeholder="Search product/supplier..." OnTextChanged="TxtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                                <button class="btn btn-outline-secondary" type="button" disabled><i class="fa-solid fa-magnifying-glass"></i></button>
                            </div>
                            <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClick="BtnReset_Click" ToolTip="Reset Search"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="GridPurchases" runat="server" AutoGenerateColumns="False" DataKeyNames="PurchaseId"
                                CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                AllowPaging="True" PageSize="5" OnPageIndexChanging="GridPurchases_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="PurchaseId" HeaderText="ID" />
                                    <asp:BoundField DataField="suppliername" HeaderText="Supplier" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                    <asp:BoundField DataField="PurchasePrice" HeaderText="Unit Price ($)" DataFormatString="{0:N2}" />
                                    <asp:TemplateField HeaderText="Total Cost ($)">
                                        <ItemTemplate>
                                            <%# (Convert.ToDecimal(Eval("PurchasePrice")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PurchaseDate" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy}" />
                                </Columns>
                                <PagerStyle CssClass="pagination-container" />
                                <EmptyDataTemplate>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fa-solid fa-receipt fs-2 mb-2 d-block"></i>
                                        No purchase records found.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
