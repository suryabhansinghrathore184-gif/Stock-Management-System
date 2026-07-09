<%@ Page Title="Sales Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="sell.aspx.cs" Inherits="StockMangementSystem.WebForm8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .sell-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .btn-action {
            padding: 4px 8px;
            font-size: 0.85rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0 text-dark">Sales Entry</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Sales</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <!-- Record Sale Form -->
            <div class="col-lg-4 mb-4">
                <div class="card card-premium sell-card">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i>Record Sale</h5>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <!-- Customer Selection -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Customer <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="DdlCustomer" runat="server" CssClass="form-select"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="ReqCustomer" runat="server" ControlToValidate="DdlCustomer" InitialValue=""
                                ErrorMessage="Please select a customer" CssClass="text-danger small d-block mt-1" ValidationGroup="SalesForm"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Product Selection -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted">Product <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="DdlProduct" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="DdlProduct_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="ReqProduct" runat="server" ControlToValidate="DdlProduct" InitialValue=""
                                ErrorMessage="Please select a product" CssClass="text-danger small d-block mt-1" ValidationGroup="SalesForm"></asp:RequiredFieldValidator>
                            <asp:Label ID="StockLabel" runat="server" CssClass="text-muted small d-block mt-1"></asp:Label>
                        </div>

                        <div class="row">
                            <!-- Unit Price -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Price ($) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPrice" runat="server" CssClass="form-control" placeholder="0.00" onkeyup="calculateTotal()"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPrice" runat="server" ControlToValidate="TxtPrice" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SalesForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValPrice" runat="server" ControlToValidate="TxtPrice" Type="Double" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid price" CssClass="text-danger small d-block mt-1" ValidationGroup="SalesForm"></asp:CompareValidator>
                            </div>
                            <!-- Quantity -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Quantity <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtQuantity" runat="server" CssClass="form-control" placeholder="0" onkeyup="calculateTotal()"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqQty" runat="server" ControlToValidate="TxtQuantity" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="SalesForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValQty" runat="server" ControlToValidate="TxtQuantity" Type="Integer" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid quantity" CssClass="text-danger small d-block mt-1" ValidationGroup="SalesForm"></asp:CompareValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Discount -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">Discount ($)</label>
                                <asp:TextBox ID="TxtDiscount" runat="server" CssClass="form-control" placeholder="0.00" Text="0.00" onkeyup="calculateTotal()"></asp:TextBox>
                            </div>
                            <!-- GST Rate -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold text-muted">GST Rate (%)</label>
                                <asp:TextBox ID="TxtGstRate" runat="server" CssClass="form-control" placeholder="18" Text="18" onkeyup="calculateTotal()"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Final Total -->
                            <div class="col-md-12 mb-3">
                                <div class="bg-light p-3 rounded-3 border border-dashed">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="fw-semibold text-muted">Estimated Total:</span>
                                        <span id="final-total" class="fs-4 fw-bold text-primary">$0.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <asp:Button ID="BtnSave" runat="server" Text="Record Sale" CssClass="btn btn-success w-100" ValidationGroup="SalesForm" OnClick="BtnSave_Click" />
                    </div>
                </div>
            </div>

            <!-- Recent Sales History Grid -->
            <div class="col-lg-8 mb-4">
                <div class="card card-premium h-100">
                    <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <h5 class="fw-bold m-0"><i class="fa-solid fa-list-check me-2 text-primary"></i>Sales Records</h5>
                        <div class="d-flex gap-2">
                            <div class="input-group input-group-sm" style="width: 240px;">
                                <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control" placeholder="Search invoice/customer..." OnTextChanged="TxtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                                <button class="btn btn-outline-secondary" type="button" disabled><i class="fa-solid fa-magnifying-glass"></i></button>
                            </div>
                            <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClick="BtnReset_Click" ToolTip="Reset Search"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="GridSales" runat="server" AutoGenerateColumns="False" DataKeyNames="SaleId"
                                CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                AllowPaging="True" PageSize="5" OnPageIndexChanging="GridSales_PageIndexChanging"
                                OnRowCommand="GridSales_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice" />
                                    <asp:BoundField DataField="customername" HeaderText="Customer" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                    <asp:BoundField DataField="SellingPrice" HeaderText="Price ($)" DataFormatString="{0:N2}" />
                                    <asp:BoundField DataField="Discount" HeaderText="Disc ($)" DataFormatString="{0:N2}" />
                                    <asp:BoundField DataField="Total" HeaderText="Total ($)" DataFormatString="{0:N2}" />
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <a href='print_invoice.aspx?invoice=<%# Eval("InvoiceNumber") %>' target="_blank" class="btn btn-sm btn-outline-primary btn-action"><i class="fa-solid fa-print"></i> Invoice</a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <PagerStyle CssClass="pagination-container" />
                                <EmptyDataTemplate>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fa-solid fa-file-invoice fs-2 mb-2 d-block"></i>
                                        No sales records found.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function calculateTotal() {
            var price = parseFloat(document.getElementById('<%= TxtPrice.ClientID %>').value) || 0;
            var qty = parseInt(document.getElementById('<%= TxtQuantity.ClientID %>').value) || 0;
            var discount = parseFloat(document.getElementById('<%= TxtDiscount.ClientID %>').value) || 0;
            var gst = parseFloat(document.getElementById('<%= TxtGstRate.ClientID %>').value) || 0;

            var subtotal = (price * qty) - discount;
            if (subtotal < 0) subtotal = 0;
            var total = subtotal + (subtotal * (gst / 100));

            document.getElementById('final-total').innerText = '$' + total.toFixed(2);
        }

        // Run calculation on load
        window.addEventListener('load', calculateTotal);
    </script>
</asp:Content>
