<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="print_invoice.aspx.cs" Inherits="StockMangementSystem.print_invoice" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Invoice - Stock Flow</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }

        .invoice-card {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            border: 1px solid #e2e8f0;
            padding: 40px;
            max-width: 800px;
            margin: 40px auto;
        }

        .invoice-header {
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .company-logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: #4f46e5;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .invoice-title {
            font-size: 2.25rem;
            font-weight: 800;
            color: #0f172a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-invoice th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
            padding: 12px;
        }

        .table-invoice td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
        }

        .totals-section {
            width: 300px;
            margin-left: auto;
            font-size: 0.95rem;
        }

        .totals-section div {
            padding: 8px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .totals-section .grand-total {
            border-bottom: 0;
            font-size: 1.2rem;
            font-weight: 700;
            color: #4f46e5;
        }

        @media print {
            body {
                background-color: #fff;
            }
            .invoice-card {
                box-shadow: none;
                border: 0;
                margin: 0;
                padding: 0;
                max-width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Print Toolbar -->
        <div class="container text-center mt-4 no-print">
            <button type="button" class="btn btn-primary px-4 py-2 me-2 shadow-sm" onclick="window.print();">
                <i class="fa-solid fa-print me-2"></i>Print Invoice
            </button>
            <button type="button" class="btn btn-outline-secondary px-4 py-2 shadow-sm" onclick="window.close();">
                <i class="fa-solid fa-xmark me-2"></i>Close Window
            </button>
        </div>

        <!-- Invoice Card -->
        <div class="invoice-card">
            <!-- Header -->
            <div class="invoice-header d-flex justify-content-between align-items-start">
                <div>
                    <div class="company-logo mb-2">
                        <i class="fa-solid fa-boxes-stacked"></i>
                        <span>STOCK FLOW Ltd.</span>
                    </div>
                    <p class="text-muted small m-0">
                        102, Business Square, IT Park Road<br />
                        Udaipur, Rajasthan, 313001<br />
                        Email: billing@stockflow.com | Ph: +91 98765 43210
                    </p>
                </div>
                <div class="text-end">
                    <span class="invoice-title d-block">Invoice</span>
                    <span class="text-muted small">Invoice No:</span>
                    <span class="fw-bold d-block text-dark"><asp:Label ID="LblInvoiceNumber" runat="server"></asp:Label></span>
                    <span class="text-muted small">Date:</span>
                    <span class="fw-semibold d-block text-dark"><asp:Label ID="LblInvoiceDate" runat="server"></asp:Label></span>
                </div>
            </div>

            <!-- Addresses -->
            <div class="row mb-5">
                <div class="col-6">
                    <span class="text-muted small d-block text-uppercase fw-semibold tracking-wider">Billed To:</span>
                    <h5 class="fw-bold text-dark mt-1 mb-2"><asp:Label ID="LblCustName" runat="server"></asp:Label></h5>
                    <p class="text-muted small m-0">
                        ID: <asp:Label ID="LblCustId" runat="server"></asp:Label><br />
                        Phone: <asp:Label ID="LblCustPhone" runat="server"></asp:Label><br />
                        Email: <asp:Label ID="LblCustEmail" runat="server"></asp:Label><br />
                        Address: <asp:Label ID="LblCustAddress" runat="server"></asp:Label><br />
                        GSTIN: <asp:Label ID="LblCustGst" runat="server"></asp:Label>
                    </p>
                </div>
                <div class="col-6 text-end">
                    <span class="text-muted small d-block text-uppercase fw-semibold tracking-wider">Payment Details:</span>
                    <h6 class="fw-bold text-dark mt-2 mb-1">Status: Paid</h6>
                    <p class="text-muted small m-0">
                        Method: Cash/Online Transaction<br />
                        Currency: USD ($)
                    </p>
                </div>
            </div>

            <!-- Items Table -->
            <div class="table-responsive mb-4">
                <table class="table table-invoice">
                    <thead>
                        <tr>
                            <th>Item Code</th>
                            <th>Description</th>
                            <th class="text-end">Price</th>
                            <th class="text-end">Qty</th>
                            <th class="text-end">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><asp:Label ID="LblItemCode" runat="server"></asp:Label></td>
                            <td class="fw-semibold"><asp:Label ID="LblItemName" runat="server"></asp:Label></td>
                            <td class="text-end">$<asp:Label ID="LblPrice" runat="server"></asp:Label></td>
                            <td class="text-end"><asp:Label ID="LblQty" runat="server"></asp:Label></td>
                            <td class="text-end">$<asp:Label ID="LblSubtotal" runat="server"></asp:Label></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Totals -->
            <div class="totals-section border-top pt-2">
                <div class="d-flex justify-content-between">
                    <span class="text-muted">Subtotal:</span>
                    <span class="fw-semibold text-dark">$<asp:Label ID="LblSummarySubtotal" runat="server"></asp:Label></span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted">Discount:</span>
                    <span class="fw-semibold text-danger">-$<asp:Label ID="LblSummaryDiscount" runat="server"></asp:Label></span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted">GST (<asp:Label ID="LblGstRate" runat="server"></asp:Label>%):</span>
                    <span class="fw-semibold text-dark">+$<asp:Label ID="LblSummaryGst" runat="server"></asp:Label></span>
                </div>
                <div class="d-flex justify-content-between grand-total">
                    <span>Total Amount:</span>
                    <span>$<asp:Label ID="LblSummaryGrandTotal" runat="server"></asp:Label></span>
                </div>
            </div>

            <!-- Footer -->
            <div class="text-center mt-5 pt-4 border-top">
                <p class="text-muted small m-0">Thank you for your business!</p>
                <p class="text-muted small m-0">For queries regarding this invoice, please reach out to billing@stockflow.com</p>
            </div>
        </div>
    </form>
</body>
</html>
