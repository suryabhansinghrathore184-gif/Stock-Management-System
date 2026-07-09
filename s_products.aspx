<%@ Page Title="My Products" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_products.aspx.cs" Inherits="StockMangementSystem.s_products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .prod-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
        .product-thumbnail {
            width: 45px;
            height: 45px;
            object-fit: cover;
            border-radius: 6px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">My Products</h3>
            <p class="text-muted small">Manage the products you supply, update stock, and upload images</p>
        </div>

        <div class="row">
            <!-- Left Card: Add / Edit Form -->
            <div class="col-lg-5 mb-4">
                <div class="card prod-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-boxes-packing text-primary me-2"></i><asp:Label ID="LblFormTitle" runat="server" Text="Add New Product"></asp:Label></h5>
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Product Code (e.g. PROD1001)</label>
                        <asp:TextBox ID="TxtCode" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Product Name</label>
                        <asp:TextBox ID="TxtName" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category</label>
                        <asp:DropDownList ID="DdlCategory" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">Purchase Price ($)</label>
                            <asp:TextBox ID="TxtPurchasePrice" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">Selling Price ($)</label>
                            <asp:TextBox ID="TxtSellingPrice" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">Stock Quantity</label>
                            <asp:TextBox ID="TxtQty" runat="server" CssClass="form-control form-control-sm" Text="0"></asp:TextBox>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">Barcode</label>
                            <asp:TextBox ID="TxtBarcode" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <asp:TextBox ID="TxtDesc" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="2"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Product Image (Max 5MB)</label>
                        <asp:FileUpload ID="FuImage" runat="server" CssClass="form-control form-control-sm" />
                    </div>

                    <asp:Button ID="BtnSaveProduct" runat="server" Text="Save Product" CssClass="btn btn-sm btn-primary me-2" OnClick="BtnSaveProduct_Click" />
                    <asp:Button ID="BtnCancel" runat="server" Text="Cancel" CssClass="btn btn-sm btn-secondary" Visible="false" OnClick="BtnCancel_Click" />
                </div>
            </div>

            <!-- Right Card: Grid of Products -->
            <div class="col-lg-7 mb-4">
                <div class="card prod-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-boxes-stacked text-success me-2"></i>Supplied Products Catalog</h5>
                    <div class="table-responsive">
                        <asp:GridView ID="GvProducts" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None"
                            DataKeyNames="ProductCode" OnRowCommand="GvProducts_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="Image">
                                    <ItemTemplate>
                                        <img src='<%# string.IsNullOrEmpty(Eval("ProductImage").ToString()) ? "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=80&q=80" : "/Links/" + Eval("ProductImage") %>' class="product-thumbnail shadow-sm border" alt="Thumbnail" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                                <asp:BoundField DataField="ProductName" HeaderText="Name" />
                                <asp:BoundField DataField="Quantity" HeaderText="Stock" />
                                <asp:TemplateField HeaderText="Price ($)">
                                    <ItemTemplate>
                                        <%# Convert.ToDecimal(Eval("SellingPrice")).ToString("N2") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="BtnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ProductCode") %>' CssClass="btn btn-xs btn-outline-primary me-1"><i class="fa-solid fa-pen"></i></asp:LinkButton>
                                        <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductCode") %>' CssClass="btn btn-xs btn-outline-danger"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-4 text-muted">
                                    No products found in your catalog.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
