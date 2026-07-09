<%@ Page Title="Category Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="categories.aspx.cs" Inherits="StockMangementSystem.categories" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .btn-action {
            padding: 4px 8px;
            font-size: 0.85rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Page Title & Breadcrumb -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h3 class="fw-bold mb-0">Category Management</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Categories</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <!-- Add / Edit Category Form -->
            <div class="col-lg-4 mb-4">
                <div class="card card-premium">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold m-0"><asp:Label ID="FormTitleLabel" runat="server" Text="Add New Category"></asp:Label></h5>
                    </div>
                    <div class="card-body">
                        <asp:HiddenField ID="CategoryIdHidden" runat="server" />
                        
                        <asp:Panel ID="AlertPanel" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                            <asp:Label ID="AlertMsgLabel" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Category Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="TxtCategoryName" runat="server" CssClass="form-control" placeholder="e.g. Electronics"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ReqCategoryName" runat="server" ControlToValidate="TxtCategoryName" 
                                ErrorMessage="Category Name is required" CssClass="text-danger small d-block mt-1" ValidationGroup="CategoryForm"></asp:RequiredFieldValidator>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <asp:TextBox ID="TxtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Optional category details"></asp:TextBox>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Status</label>
                            <asp:DropDownList ID="DdlStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="d-flex gap-2">
                            <asp:Button ID="BtnSave" runat="server" Text="Save Category" CssClass="btn btn-primary w-100" ValidationGroup="CategoryForm" OnClick="BtnSave_Click" />
                            <asp:Button ID="BtnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary w-100" OnClick="BtnCancel_Click" Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Categories List Grid -->
            <div class="col-lg-8 mb-4">
                <div class="card card-premium h-100">
                    <div class="card-header bg-white border-0 pt-4 pb-0 d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <h5 class="fw-bold m-0">Category Directory</h5>
                        
                        <!-- Search Box -->
                        <div class="d-flex gap-2 align-items-center">
                            <div class="input-group input-group-sm" style="width: 240px;">
                                <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control" placeholder="Search categories..." OnTextChanged="TxtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                                <button class="btn btn-outline-secondary" type="button" disabled><i class="fa-solid fa-magnifying-glass"></i></button>
                            </div>
                            <asp:LinkButton ID="BtnReset" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClick="BtnReset_Click" ToolTip="Reset Search"><i class="fa-solid fa-rotate-left"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="GridCategories" runat="server" AutoGenerateColumns="False" DataKeyNames="CategoryId"
                                CssClass="table table-hover table-premium align-middle mb-0" GridLines="None"
                                AllowPaging="True" PageSize="5" OnPageIndexChanging="GridCategories_PageIndexChanging"
                                OnRowCommand="GridCategories_RowCommand" OnRowDeleting="GridCategories_RowDeleting">
                                <Columns>
                                    <asp:BoundField DataField="CategoryId" HeaderText="ID" SortExpression="CategoryId" />
                                    <asp:BoundField DataField="CategoryName" HeaderText="Category Name" SortExpression="CategoryName" />
                                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" NullDisplayText="-" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='badge <%# Eval("Status").ToString() == "Active" ? "bg-success-subtle text-success" : "bg-danger-subtle text-danger" %> px-2.5 py-1.5'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="BtnEdit" runat="server" CommandName="EditCategory" CommandArgument='<%# Eval("CategoryId") %>' CssClass="btn btn-sm btn-outline-primary btn-action me-1"><i class="fa-regular fa-pen-to-square"></i> Edit</asp:LinkButton>
                                            <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryId") %>' CssClass="btn btn-sm btn-outline-danger btn-action" OnClientClick="return confirmDeleteCategory(this);"><i class="fa-regular fa-trash-can"></i> Delete</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <PagerStyle CssClass="pagination-container" />
                                <EmptyDataTemplate>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fa-regular fa-folder-open fs-2 mb-2 d-block"></i>
                                        No categories found.
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
        function confirmDeleteCategory(btn) {
            if (btn.dataset.confirmed) {
                return true;
            }
            Swal.fire({
                title: 'Delete Category?',
                text: 'Are you sure you want to delete this category? All linked products will be affected.',
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
