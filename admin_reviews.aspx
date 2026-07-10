<%@ Page Title="Product Reviews Moderation" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="admin_reviews.aspx.cs" Inherits="StockMangementSystem.admin_reviews" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .review-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
        .star-rating {
            color: #fbbf24;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid p-0">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Product Reviews Moderation</h3>
            <p class="text-muted small">Monitor and moderate reviews submitted by customers on catalog products</p>
        </div>

        <!-- Filter bar -->
        <div class="card review-card p-4">
            <div class="row align-items-end">
                <div class="col-md-5 mb-2">
                    <label class="form-label small fw-bold">Search by Product Name or Customer ID</label>
                    <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control form-control-sm" Placeholder="e.g. Samsung / 101"></asp:TextBox>
                </div>
                <div class="col-md-3 mb-2">
                    <label class="form-label small fw-bold">Filter by Rating</label>
                    <asp:DropDownList ID="DdlRatingFilter" runat="server" CssClass="form-select form-select-sm">
                        <asp:ListItem Text="All Ratings" Value=""></asp:ListItem>
                        <asp:ListItem Text="5 Stars Only" Value="5"></asp:ListItem>
                        <asp:ListItem Text="4 Stars Only" Value="4"></asp:ListItem>
                        <asp:ListItem Text="3 Stars Only" Value="3"></asp:ListItem>
                        <asp:ListItem Text="2 Stars Only" Value="2"></asp:ListItem>
                        <asp:ListItem Text="1 Star Only" Value="1"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4 mb-2">
                    <asp:Button ID="BtnSearch" runat="server" Text="Filter" CssClass="btn btn-sm btn-primary me-2" OnClick="BtnSearch_Click" />
                    <asp:Button ID="BtnClear" runat="server" Text="Clear" CssClass="btn btn-sm btn-outline-secondary" OnClick="BtnClear_Click" />
                </div>
            </div>
        </div>

        <!-- Reviews Grid -->
        <div class="card review-card p-4">
            <div class="table-responsive">
                <asp:GridView ID="GvReviews" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" GridLines="None"
                    DataKeyNames="ReviewId" OnRowDeleting="GvReviews_RowDeleting"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="GvReviews_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="ReviewId" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="CustomerId" HeaderText="Customer ID" ReadOnly="True" />
                        <asp:BoundField DataField="ProductName" HeaderText="Product" ReadOnly="True" />
                        
                        <!-- Rating -->
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <span class="star-rating">
                                    <%# GetStars(Eval("Rating")) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- Comment -->
                        <asp:BoundField DataField="ReviewText" HeaderText="Review Comment" />
                        
                        <!-- Date -->
                        <asp:TemplateField HeaderText="Submitted Date">
                            <ItemTemplate>
                                <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd-MM-yyyy HH:mm") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- Delete Action -->
                        <asp:CommandField ShowDeleteButton="True" DeleteText="Remove" 
                            ControlStyle-CssClass="btn btn-xs btn-outline-danger" ButtonType="Button" />
                    </Columns>
                    <PagerStyle CssClass="pagination-container" />
                    <EmptyDataTemplate>
                        <div class="text-center py-4 text-muted">
                            No product reviews found matching the filter search.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
