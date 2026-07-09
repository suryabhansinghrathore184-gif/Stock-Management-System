<%@ Page Title="Address Book" Language="C#" MasterPageFile="~/customer.Master" AutoEventWireup="true" CodeBehind="c_addressbook.aspx.cs" Inherits="StockMangementSystem.c_addressbook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .address-card {
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
            <h3 class="fw-bold mb-0 text-dark">Address Book</h3>
            <p class="text-muted small">Manage your billing and shipping addresses for orders and deliveries</p>
        </div>

        <div class="row">
            <!-- Left Side: Add / Edit Address Form -->
            <div class="col-lg-5 mb-4">
                <div class="card address-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-location-dot text-primary me-2"></i><asp:Label ID="LblFormTitle" runat="server" Text="Add New Address"></asp:Label></h5>
                    <asp:HiddenField ID="HfAddressId" runat="server" />
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Contact Name</label>
                        <asp:TextBox ID="TxtContactName" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Phone Number</label>
                        <asp:TextBox ID="TxtPhone" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Street Address</label>
                        <asp:TextBox ID="TxtStreet" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="2"></asp:TextBox>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">City</label>
                            <asp:TextBox ID="TxtCity" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">State</label>
                            <asp:TextBox ID="TxtState" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">Postal / ZIP Code</label>
                            <asp:TextBox ID="TxtPostal" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-semibold">Country</label>
                            <asp:TextBox ID="TxtCountry" runat="server" CssClass="form-control form-control-sm" Text="India"></asp:TextBox>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="form-check">
                            <asp:CheckBox ID="ChkDefaultBilling" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label fw-semibold" for='<%= ChkDefaultBilling.ClientID %>'>Set as Default Billing Address</label>
                        </div>
                        <div class="form-check mt-1">
                            <asp:CheckBox ID="ChkDefaultShipping" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label fw-semibold" for='<%= ChkDefaultShipping.ClientID %>'>Set as Default Shipping Address</label>
                        </div>
                    </div>
                    
                    <asp:Button ID="BtnSaveAddress" runat="server" Text="Save Address" CssClass="btn btn-sm btn-primary me-2" OnClick="BtnSaveAddress_Click" />
                    <asp:Button ID="BtnCancel" runat="server" Text="Cancel" CssClass="btn btn-sm btn-secondary" Visible="false" OnClick="BtnCancel_Click" />
                </div>
            </div>

            <!-- Right Side: Grid of Saved Addresses -->
            <div class="col-lg-7 mb-4">
                <div class="card address-card p-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-address-book text-success me-2"></i>Saved Addresses</h5>
                    <div class="table-responsive">
                        <asp:GridView ID="GvAddresses" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover align-middle mb-0" GridLines="None"
                            DataKeyNames="AddressId" OnRowCommand="GvAddresses_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                <asp:TemplateField HeaderText="Address">
                                    <ItemTemplate>
                                        <%# Eval("AddressLine") %>, <%# Eval("City") %>, <%# Eval("State") %> - <%# Eval("PostalCode") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Defaults">
                                    <ItemTemplate>
                                        <span class='badge bg-info <%# Convert.ToBoolean(Eval("IsDefaultBilling")) ? "" : "d-none" %>'>Billing</span>
                                        <span class='badge bg-primary <%# Convert.ToBoolean(Eval("IsDefaultShipping")) ? "" : "d-none" %>'>Shipping</span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="BtnEdit" runat="server" CommandName="EditAddress" CommandArgument='<%# Eval("AddressId") %>' CssClass="btn btn-xs btn-outline-primary me-1"><i class="fa-solid fa-pen"></i></asp:LinkButton>
                                        <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteAddress" CommandArgument='<%# Eval("AddressId") %>' CssClass="btn btn-xs btn-outline-danger"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-3 text-muted">
                                    No saved addresses found.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
