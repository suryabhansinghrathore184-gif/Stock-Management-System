<%@ Page Title="My Wishlist" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_wishlist.aspx.cs" Inherits="StockMangementSystem.c_wishlist" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .wishlist-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">My Wishlist & Product Catalog</h3>
            <p class="text-muted small">Save products to your wishlist or make direct simulated purchases</p>
        </div>

        <!-- Section 1: My Wishlist -->
        <div class="card wishlist-card">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0 text-danger"><i class="fa-solid fa-heart me-2"></i>My Wishlist</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GvWishlist" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle mb-0" GridLines="None"
                        OnRowCommand="GvWishlist_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                            <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                            
                            <!-- Price -->
                            <asp:TemplateField HeaderText="Price ($)">
                                <ItemTemplate>
                                    <%# Convert.ToDecimal(Eval("SellingPrice")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Availability -->
                            <asp:TemplateField HeaderText="Availability">
                                <ItemTemplate>
                                    <span class='badge <%# Convert.ToInt32(Eval("Quantity")) > 0 ? "bg-success" : "bg-danger" %>'>
                                        <%# Convert.ToInt32(Eval("Quantity")) > 0 ? "In Stock" : "Out of Stock" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Actions -->
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="BtnBuy" runat="server" CommandName="BuyItem" CommandArgument='<%# Eval("ProductCode") %>' 
                                        CssClass="btn btn-sm btn-success me-2" Enabled='<%# Convert.ToInt32(Eval("Quantity")) > 0 %>'>
                                        <i class="fa-solid fa-cart-shopping me-1"></i>Buy Now
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="BtnRemove" runat="server" CommandName="RemoveWish" CommandArgument='<%# Eval("ProductCode") %>' 
                                        CssClass="btn btn-sm btn-outline-danger">
                                        <i class="fa-solid fa-trash"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-heart-broken fs-2 mb-2 d-block text-secondary"></i>
                                Your wishlist is empty. Add products from the catalog below!
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Section 2: Catalog -->
        <div class="card wishlist-card">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0 text-primary"><i class="fa-solid fa-store me-2"></i>Product Catalog</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GvCatalog" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle mb-0" GridLines="None"
                        OnRowCommand="GvCatalog_RowCommand" AllowPaging="True" PageSize="5"
                        OnPageIndexChanging="GvCatalog_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="ProductCode" HeaderText="Code" />
                            <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                            
                            <!-- Price -->
                            <asp:TemplateField HeaderText="Price ($)">
                                <ItemTemplate>
                                    <%# Convert.ToDecimal(Eval("SellingPrice")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Stock -->
                            <asp:TemplateField HeaderText="Stock Qty">
                                <ItemTemplate>
                                    <%# Eval("Quantity") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Actions -->
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="BtnAddWish" runat="server" CommandName="AddWish" CommandArgument='<%# Eval("ProductCode") %>' 
                                        CssClass="btn btn-sm btn-primary">
                                        <i class="fa-solid fa-heart me-1"></i>Add to Wishlist
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                No products available in the catalog.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
