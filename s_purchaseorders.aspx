<%@ Page Title="Inbound Purchase Orders" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_purchaseorders.aspx.cs" Inherits="StockMangementSystem.s_purchaseorders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .po-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            #printArea, #printArea * {
                visibility: visible;
            }
            #printArea {
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
            <h3 class="fw-bold mb-0 text-dark">Purchase Orders</h3>
            <p class="text-muted small">Manage inbound requests from administrative procurement</p>
        </div>

        <!-- PO Table Grid -->
        <div class="card po-card">
            <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Purchase Orders Logs</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GvPOs" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle mb-0" GridLines="None"
                        DataKeyNames="PurchaseId" OnRowCommand="GvPOs_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="PurchaseId" HeaderText="PO Number" />
                            <asp:TemplateField HeaderText="Order Date">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("PurchaseDate")).ToString("dd-MM-yyyy") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                            
                            <!-- Unit Price -->
                            <asp:TemplateField HeaderText="Unit Price ($)">
                                <ItemTemplate>
                                    <%# Convert.ToDecimal(Eval("PurchasePrice")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Total -->
                            <asp:TemplateField HeaderText="Total Price ($)">
                                <ItemTemplate>
                                    <%# (Convert.ToDecimal(Eval("PurchasePrice")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Status -->
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("DeliveryStatus").ToString() == "Delivered" ? "bg-success" : (Eval("DeliveryStatus").ToString() == "In Transit" ? "bg-info" : "bg-warning") %>'>
                                        <%# Eval("DeliveryStatus") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Actions -->
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="BtnPrint" runat="server" CommandName="PrintPO" CommandArgument='<%# Eval("PurchaseId") %>' 
                                        CssClass="btn btn-sm btn-outline-primary py-1 px-2.5">
                                        <i class="fa-solid fa-print me-1"></i>Print
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-file-invoice fs-2 mb-2 d-block"></i>
                                No purchase orders found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Print PO Overlay Panel -->
        <asp:Panel ID="PanelPrintOverlay" runat="server" CssClass="modal fade show d-block bg-dark bg-opacity-50" Visible="false">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header border-0 no-print">
                        <h5 class="modal-title fw-bold">Purchase Order Print Preview</h5>
                        <asp:Button ID="BtnClosePreview" runat="server" CssClass="btn-close" OnClick="BtnClosePreview_Click" />
                    </div>
                    <div class="modal-body p-5 bg-white" id="printArea">
                        <div class="d-flex justify-content-between mb-4">
                            <div>
                                <h3 class="fw-bold text-primary mb-1">PURCHASE ORDER</h3>
                                <span class="text-muted">PO ID: #<asp:Label ID="PrintPoId" runat="server"></asp:Label></span>
                            </div>
                            <div class="text-end">
                                <h5 class="fw-bold m-0"><asp:Label ID="PrintCompName" runat="server"></asp:Label></h5>
                                <span class="text-muted small">GSTIN: <asp:Label ID="PrintGst" runat="server"></asp:Label></span>
                            </div>
                        </div>
                        <hr />
                        <div class="row my-4">
                            <div class="col-6">
                                <h6 class="fw-bold text-uppercase text-muted" style="font-size: 0.75rem;">From (Supplier)</h6>
                                <p class="mb-1 fw-bold"><asp:Label ID="PrintSuppName" runat="server"></asp:Label></p>
                                <p class="mb-1 text-muted small"><asp:Label ID="PrintSuppAddress" runat="server"></asp:Label></p>
                                <p class="text-muted small">Email: <asp:Label ID="PrintSuppEmail" runat="server"></asp:Label></p>
                            </div>
                            <div class="col-6 text-end">
                                <h6 class="fw-bold text-uppercase text-muted" style="font-size: 0.75rem;">To (Billing Address)</h6>
                                <p class="mb-1 fw-bold">StockFlow Inc.</p>
                                <p class="mb-1 text-muted small">Sector 5, Salt Lake City</p>
                                <p class="text-muted small">Kolkata, WB, India</p>
                            </div>
                        </div>
                        <table class="table table-bordered align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Item Description</th>
                                    <th class="text-center">Quantity</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><asp:Label ID="PrintProdName" runat="server"></asp:Label></td>
                                    <td class="text-center"><asp:Label ID="PrintQty" runat="server"></asp:Label></td>
                                    <td class="text-end">$<asp:Label ID="PrintUnit" runat="server"></asp:Label></td>
                                    <td class="text-end">$<asp:Label ID="PrintTotal" runat="server"></asp:Label></td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="row mt-5">
                            <div class="col-6">
                                <h6 class="fw-bold text-muted small uppercase">Status</h6>
                                <span class="badge bg-success"><asp:Label ID="PrintStatus" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-6 text-end">
                                <span class="text-muted small">Authorized Signatory</span>
                                <div class="mt-4 border-bottom d-inline-block" style="width: 150px;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 no-print">
                        <button type="button" class="btn btn-primary" onclick="window.print()"><i class="fa-solid fa-print me-1.5"></i>Print PO</button>
                        <asp:Button ID="BtnCancelPreview" runat="server" CssClass="btn btn-secondary" Text="Close" OnClick="BtnClosePreview_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
