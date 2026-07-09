<%@ Page Title="Product Reviews" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_feedback.aspx.cs" Inherits="StockMangementSystem.c_feedback" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .review-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 24px;
        }
        .star-rating {
            color: #fbbf24; /* yellow star color */
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="mb-4">
            <h3 class="fw-bold mb-0 text-dark">Product Feedback & Reviews</h3>
            <p class="text-muted small">Rate your purchased items and help others choose better products</p>
        </div>

        <div class="row">
            <!-- Left Card: Write a Review -->
            <div class="col-lg-5 mb-4">
                <div class="card review-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-pen-to-square text-primary me-2"></i>Write a Product Review</h5>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Product</label>
                        <asp:DropDownList ID="DdlProducts" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Rating (1 to 5 Stars)</label>
                        <asp:DropDownList ID="DdlRating" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="⭐⭐⭐⭐⭐ (5 - Excellent)" Value="5"></asp:ListItem>
                            <asp:ListItem Text="⭐⭐⭐⭐ (4 - Very Good)" Value="4"></asp:ListItem>
                            <asp:ListItem Text="⭐⭐⭐ (3 - Average)" Value="3"></asp:ListItem>
                            <asp:ListItem Text="⭐⭐ (2 - Poor)" Value="2"></asp:ListItem>
                            <asp:ListItem Text="⭐ (1 - Terrible)" Value="1"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Your Comments</label>
                        <asp:TextBox ID="TxtReviewText" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                    <asp:Button ID="BtnSubmitReview" runat="server" Text="Submit Review" CssClass="btn btn-sm btn-primary" OnClick="BtnSubmitReview_Click" />
                </div>
            </div>

            <!-- Right Card: View/Edit Previous Reviews -->
            <div class="col-lg-7 mb-4">
                <div class="card review-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-list-ul text-success me-2"></i>My Reviews History</h5>
                    <div class="table-responsive">
                        <asp:GridView ID="GvReviews" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None"
                            DataKeyNames="ReviewId" OnRowDeleting="GvReviews_RowDeleting"
                            OnRowEditing="GvReviews_RowEditing" OnRowUpdating="GvReviews_RowUpdating"
                            OnRowCancelingEdit="GvReviews_RowCancelingEdit">
                            <Columns>
                                <asp:BoundField DataField="ReviewId" HeaderText="ID" ReadOnly="True" />
                                <asp:BoundField DataField="ProductName" HeaderText="Product" ReadOnly="True" />
                                
                                <asp:TemplateField HeaderText="Rating">
                                    <ItemTemplate>
                                        <span class="star-rating">
                                            <%# new string('★', Convert.ToInt32(Eval("Rating"))) + new string('☆', 5 - Convert.ToInt32(Eval("Rating"))) %>
                                        </span>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="DdlEditRating" runat="server" CssClass="form-select form-select-xs" SelectedValue='<%# Bind("Rating") %>'>
                                            <asp:ListItem Text="5 Stars" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="4 Stars" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="3 Stars" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="2 Stars" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="1 Star" Value="1"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Review Comment">
                                    <ItemTemplate>
                                        <%# Eval("ReviewText") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TxtEditReviewText" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("ReviewText") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" 
                                    ControlStyle-CssClass="btn btn-xs btn-outline-secondary me-1"
                                    ButtonType="Button" />
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-3 text-muted">
                                    You have not reviewed any products.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
