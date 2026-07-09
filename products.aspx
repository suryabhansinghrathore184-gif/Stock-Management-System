<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="products.aspx.cs" Inherits="StockMangementSystem.products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .product-img-th {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid var(--border-color);
        }
        .product-preview {
            max-width: 120px;
            max-height: 120px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            margin-top: 10px;
        }
        .btn-action {
            padding: 4px 8px;
            font-size: 0.85rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0">Product Management</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Products</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <!-- Add / Edit Product Form -->
            <div class="col-xl-4 col-lg-5 mb-4">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><asp:Label ID="FormTitleLabel" runat="server" Text="Add New Product"></asp:Label></h5>
                    </div>
                    <div class="card-body">
                        <asp:HiddenField ID="EditModeHidden" runat="server" Value="false" />
                        
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <!-- Product Code -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product Code <span class="text-danger">*</span></label>
                            <asp:TextBox ID="TxtProductCode" runat="server" CssClass="form-control" placeholder="e.g. PROD1001"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ReqProductCode" runat="server" ControlToValidate="TxtProductCode" 
                                ErrorMessage="Product Code is required" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                        </div>

                        <!-- Product Name -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="TxtProductName" runat="server" CssClass="form-control" placeholder="Samsung Galaxy S23"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ReqProductName" runat="server" ControlToValidate="TxtProductName" 
                                ErrorMessage="Product Name is required" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                        </div>

                        <div class="row">
                            <!-- Category -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DdlCategory" runat="server" CssClass="form-select"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ReqCategory" runat="server" ControlToValidate="DdlCategory" InitialValue=""
                                    ErrorMessage="Select category" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                            </div>
                            <!-- Supplier -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Supplier <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="DdlSupplier" runat="server" CssClass="form-select"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ReqSupplier" runat="server" ControlToValidate="DdlSupplier" InitialValue=""
                                    ErrorMessage="Select supplier" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Purchase Price -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Purchase Price ($) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtPurchasePrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqPurPrice" runat="server" ControlToValidate="TxtPurchasePrice" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValPurPrice" runat="server" ControlToValidate="TxtPurchasePrice" Type="Double" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid amount" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:CompareValidator>
                            </div>
                            <!-- Selling Price -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Selling Price ($) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtSellingPrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqSellPrice" runat="server" ControlToValidate="TxtSellingPrice" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValSellPrice" runat="server" ControlToValidate="TxtSellingPrice" Type="Double" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid amount" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:CompareValidator>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Initial Stock Quantity -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Initial Stock <span class="text-danger">*</span></label>
                                <asp:TextBox ID="TxtQuantity" runat="server" CssClass="form-control" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ReqQty" runat="server" ControlToValidate="TxtQuantity" 
                                    ErrorMessage="Required" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="ValQty" runat="server" ControlToValidate="TxtQuantity" Type="Integer" Operator="DataTypeCheck"
                                    ErrorMessage="Invalid quantity" CssClass="text-danger small d-block mt-1" ValidationGroup="ProductForm"></asp:CompareValidator>
                            </div>
                            <!-- Barcode -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Barcode</label>
                                <asp:TextBox ID="TxtBarcode" runat="server" CssClass="form-control" placeholder="e.g. EAN-13"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <asp:TextBox ID="TxtDescription" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="Product details..."></asp:TextBox>
                        </div>

                        <!-- Product Image -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Product Image</label>
                            <asp:FileUpload ID="FileProductImage" runat="server" CssClass="form-control" onchange="previewImage(this);" />
                            <div class="d-flex align-items-center gap-3">
                                <asp:Image ID="ImgPreview" runat="server" CssClass="product-preview d-none" />
                                <asp:LinkButton ID="BtnRemoveImage" runat="server" CssClass="btn btn-sm btn-outline-danger d-none mt-3" OnClick="BtnRemoveImage_Click"><i class="fa-regular fa-trash-can"></i> Remove Image</asp:LinkButton>
                            </div>
                            <asp:HiddenField ID="CurrentImagePath" runat="server" />
                        </div>

                        <div class="d-flex gap-2">
                            <asp:Button ID="BtnSave" runat="server" Text="Save Product" CssClass="btn btn-primary w-100" ValidationGroup="ProductForm" OnClick="BtnSave_Click" />
                            <asp:Button ID="BtnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary w-100" OnClick="BtnCancel_Click" Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Products List Grid -->
            <div class="col-xl-8 col-lg-7 mb-4">
                <div class="card card-premium h-100">
                    <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <h5 class="fw-bold m-0">Product Catalog</h5>
                        
                        <!-- Search & Category Filters -->
                        <div class="d-flex flex-wrap gap-2 align-items-center">
                            <!-- Filter Category -->
                            <asp:DropDownList ID="DdlFilterCategory" runat="server" CssClass="form-select form-select-sm" style="width: 160px;"
                                AutoPostBack="true" OnSelectedIndexChanged="DdlFilterCategory_SelectedIndexChanged">
                            </asp:DropDownList>
                            
                            <!-- Search -->
                            <div class="input-group input-group-sm" style="width: 200px;">
                                <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control" placeholder="Search code/name..." OnTextChanged="TxtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                                <button class="btn btn-outline-secondary" type="button" disabled><i class="fa-solid fa-magnifying-glass"></i></button>
                            </div>
                            <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClick="BtnReset_Click" ToolTip="Reset Filters"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="GridProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductCode"
                                CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                AllowPaging="True" PageSize="5" OnPageIndexChanging="GridProducts_PageIndexChanging"
                                OnRowCommand="GridProducts_RowCommand" OnRowDeleting="GridProducts_RowDeleting">
                                <Columns>
                                    <asp:TemplateField HeaderText="Image">
                                        <ItemTemplate>
                                            <img src='<%# string.IsNullOrEmpty(Eval("ProductImage").ToString()) ? "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=80&q=80" : "/Links/" + Eval("ProductImage") %>' class="product-img-th" alt="product" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ProductCode" HeaderText="Code" SortExpression="ProductCode" />
                                    <asp:BoundField DataField="ProductName" HeaderText="Name" SortExpression="ProductName" />
                                    <asp:BoundField DataField="CategoryName" HeaderText="Category" SortExpression="CategoryName" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Stock" SortExpression="Quantity" />
                                    <asp:BoundField DataField="SellingPrice" HeaderText="Price ($)" SortExpression="SellingPrice" DataFormatString="{0:N2}" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='badge <%# Convert.ToInt32(Eval("Quantity")) == 0 ? "bg-danger-subtle text-danger" : (Convert.ToInt32(Eval("Quantity")) <= 10 ? "bg-warning-subtle text-warning" : "bg-success-subtle text-success") %> px-2 py-1'>
                                                <%# Convert.ToInt32(Eval("Quantity")) == 0 ? "Out of Stock" : (Convert.ToInt32(Eval("Quantity")) <= 10 ? "Low Stock" : "In Stock") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="BtnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ProductCode") %>' CssClass="btn btn-sm btn-outline-primary btn-action me-1"><i class="fa-regular fa-pen-to-square"></i></asp:LinkButton>
                                            <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductCode") %>' CssClass="btn btn-sm btn-outline-danger btn-action" OnClientClick="return confirmDeleteProduct(this);"><i class="fa-regular fa-trash-can"></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <PagerStyle CssClass="pagination-container" />
                                <EmptyDataTemplate>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fa-regular fa-face-frown fs-2 mb-2 d-block"></i>
                                        No products match the criteria.
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
        // Preview uploaded image
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var img = document.getElementById('<%= ImgPreview.ClientID %>');
                    img.src = e.target.result;
                    img.classList.remove('d-none');
                    document.getElementById('<%= BtnRemoveImage.ClientID %>').classList.remove('d-none');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function confirmDeleteProduct(btn) {
            if (btn.dataset.confirmed) {
                return true;
            }
            Swal.fire({
                title: 'Delete Product?',
                text: 'Are you sure you want to delete this product? All transaction history will be deleted.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#4f46e5',
                cancelButtonColor: '#ef4444',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    btn.dataset.confirmed = true;
                    btn.click();
                }
            });
            return false;
        }
    </script>
</asp:Content>
