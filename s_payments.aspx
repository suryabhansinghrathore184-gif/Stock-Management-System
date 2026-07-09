<%@ Page Title="My Payments" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_payments.aspx.cs" Inherits="StockMangementSystem.s_payments" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .payments-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            #printReceipt, #printReceipt * {
                visibility: visible;
            }
            #printReceipt {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Payment History</h3>
            <p class="text-muted small">Monitor your incoming payments, paid invoices, and pending vouchers</p>
        </div>

        <!-- Summary stats -->
        <div class="row mb-4">
            <div class="col-md-6 mb-3">
                <div class="card border-0 shadow-sm p-4 bg-white border-start border-4 border-success">
                    <span class="text-muted small fw-semibold text-uppercase">Total Paid</span>
                    <h3 class="fw-bold text-success mb-0 mt-1">$<asp:Label ID="LblTotalPaid" runat="server" Text="0.00"></asp:Label></h3>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <div class="card border-0 shadow-sm p-4 bg-white border-start border-4 border-warning">
                    <span class="text-muted small fw-semibold text-uppercase">Total Pending</span>
                    <h3 class="fw-bold text-warning mb-0 mt-1">$<asp:Label ID="LblTotalPending" runat="server" Text="0.00"></asp:Label></h3>
                </div>
            </div>
        </div>

        <!-- Payments Table Grid -->
        <div class="card payments-card">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-wallet text-success me-2"></i>Invoice Payments Ledger</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GvPayments" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle mb-0" GridLines="None"
                        DataKeyNames="PurchaseId" OnRowCommand="GvPayments_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="PurchaseId" HeaderText="Payment ID / PO ID" />
                            <asp:TemplateField HeaderText="Payment Date">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("PurchaseDate")).ToString("dd-MM-yyyy") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ProductName" HeaderText="Supplied Item" />
                            <asp:TemplateField HeaderText="Amount ($)">
                                <ItemTemplate>
                                    <%# (Convert.ToDecimal(Eval("PurchasePrice")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Method">
                                <ItemTemplate>
                                    Bank Transfer
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("PaymentStatus").ToString() == "Paid" ? "bg-success" : "bg-warning" %>'>
                                        <%# Eval("PaymentStatus") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="BtnReceipt" runat="server" CommandName="PrintReceipt" CommandArgument='<%# Eval("PurchaseId") %>' 
                                        CssClass="btn btn-sm btn-outline-secondary py-1 px-2.5" Enabled='<%# Eval("PaymentStatus").ToString() == "Paid" %>'>
                                        <i class="fa-solid fa-receipt me-1"></i>Receipt
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-wallet fs-2 mb-2 d-block"></i>
                                No payment logs found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Print Receipt Overlay Panel -->
        <asp:Panel ID="PanelReceiptOverlay" runat="server" CssClass="modal fade show d-block bg-dark bg-opacity-50" Visible="false">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header border-0 no-print">
                        <h5 class="modal-title fw-bold">Payment Receipt Preview</h5>
                        <asp:Button ID="BtnCloseReceipt" runat="server" CssClass="btn-close" OnClick="BtnCloseReceipt_Click" />
                    </div>
                    <div class="modal-body p-4 bg-white text-center" id="printReceipt">
                        <div class="mb-4">
                            <i class="fa-solid fa-circle-check text-success fs-1"></i>
                            <h3 class="fw-bold mt-2 text-dark">PAYMENT RECEIPT</h3>
                            <span class="text-muted small">Receipt No: RCP-<%# PrintReceiptPoId.Text %></span>
                        </div>
                        <hr />
                        <div class="text-start my-4">
                            <div class="row mb-2">
                                <div class="col-6 text-muted">Payment Date:</div>
                                <div class="col-6 text-end fw-bold"><asp:Label ID="PrintReceiptDate" runat="server"></asp:Label></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6 text-muted">Paid To (Supplier ID):</div>
                                <div class="col-6 text-end fw-bold"><asp:Label ID="PrintReceiptSupp" runat="server"></asp:Label></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6 text-muted">Supplied Product:</div>
                                <div class="col-6 text-end fw-bold"><asp:Label ID="PrintReceiptProd" runat="server"></asp:Label></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6 text-muted">Quantity:</div>
                                <div class="col-6 text-end fw-bold"><asp:Label ID="PrintReceiptQty" runat="server"></asp:Label></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6 text-muted">Payment Method:</div>
                                <div class="col-6 text-end fw-bold">Bank Transfer</div>
                            </div>
                            <hr />
                            <div class="row my-3 fs-5">
                                <div class="col-6 text-dark fw-bold">Total Paid Amount:</div>
                                <div class="col-6 text-end text-success fw-bold">$<asp:Label ID="PrintReceiptTotal" runat="server"></asp:Label></div>
                            </div>
                        </div>
                        <div class="text-center text-muted small mt-4">
                            This is an electronically generated payment receipt from StockFlow procurement portal.
                        </div>
                    </div>
                    <div class="modal-footer border-0 no-print">
                        <button type="button" class="btn btn-primary" onclick="window.print()"><i class="fa-solid fa-print me-1.5"></i>Print Receipt</button>
                        <asp:Button ID="BtnCancelReceipt" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="BtnCloseReceipt_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Label ID="PrintReceiptPoId" runat="server" Visible="false"></asp:Label>
    </div>
</asp:Content>
