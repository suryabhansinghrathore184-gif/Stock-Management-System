<%@ Page Title="Delivery Schedule" Language="C#" MasterPageFile="~/supplier.Master" AutoEventWireup="true" CodeBehind="s_deliveryschedule.aspx.cs" Inherits="StockMangementSystem.s_deliveryschedule" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .schedule-card {
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
            <h3 class="fw-bold mb-0 text-dark">Delivery Schedule</h3>
            <p class="text-muted small">Monitor pending dispatches and update delivery statuses</p>
        </div>

        <!-- Schedule Registry -->
        <div class="card schedule-card">
            <div class="card-header bg-white border-0 pt-4 pb-0">
                <h5 class="fw-bold m-0"><i class="fa-solid fa-calendar-days text-danger me-2"></i>Shipments Delivery Schedule</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="GvSchedule" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle mb-0" GridLines="None"
                        DataKeyNames="PurchaseId" OnRowUpdating="GvSchedule_RowUpdating"
                        OnRowEditing="GvSchedule_RowEditing" OnRowCancelingEdit="GvSchedule_RowCancelingEdit">
                        <Columns>
                            <asp:BoundField DataField="PurchaseId" HeaderText="PO ID / Track ID" ReadOnly="True" />
                            <asp:BoundField DataField="ProductName" HeaderText="Item Name" ReadOnly="True" />
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" ReadOnly="True" />
                            
                            <!-- Date -->
                            <asp:TemplateField HeaderText="Scheduled Date">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("PurchaseDate")).ToString("dd-MM-yyyy") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <!-- Status Dropdown Edit -->
                            <asp:TemplateField HeaderText="Delivery Status">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("DeliveryStatus").ToString() == "Delivered" ? "bg-success" : (Eval("DeliveryStatus").ToString() == "In Transit" ? "bg-info" : "bg-warning") %>'>
                                        <%# Eval("DeliveryStatus") %>
                                    </span>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DdlEditStatus" runat="server" CssClass="form-select form-select-xs" SelectedValue='<%# Bind("DeliveryStatus") %>'>
                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                        <asp:ListItem Text="In Transit" Value="In Transit"></asp:ListItem>
                                        <asp:ListItem Text="Delivered" Value="Delivered"></asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <!-- Actions -->
                            <asp:CommandField ShowEditButton="True" ControlStyle-CssClass="btn btn-xs btn-outline-secondary me-1" ButtonType="Button" />
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4 text-muted">
                                <i class="fa-solid fa-calendar-times fs-2 mb-2 d-block"></i>
                                No scheduled deliveries found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
