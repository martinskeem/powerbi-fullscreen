<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PowerBiFullScreen.Default" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="scripts/powerbi.js"></script>

    <script type="text/javascript">
        var r;

        window.onload = function () {
            var accessToken = document.getElementById('MainContent_accessToken').value;

            if (!accessToken || accessToken == "")
            {
                return;
            }

            var embedUrl = document.getElementById('MainContent_hdEmbedUrl').value;
            var reportId = document.getElementById('MainContent_hdReportId').value;
            var reportSection = document.getElementById('MainContent_hdReportSection').value;

            var config= {
                type: 'report',
                accessToken: accessToken,
                embedUrl: embedUrl,
                id: reportId,
                pageName: reportSection,
                settings: {
                    filterPaneEnabled: false,
                    navContentPaneEnabled: false
                }
            };

            var reportContainer = document.getElementById('reportContainer');

            r = powerbi.embed(reportContainer, config);
        };

        window.setInterval(function () {
            r.refresh();
        }, 10000)
    </script>

    <style>
        #reportContainer {
            position: absolute;
            top: 0; right: 0; bottom: 0; left: 0;
            overflow: hidden;
            width:100%;
            height:100%;
        }

        body {
            overflow: hidden;
        }

        iframe {
            border: 0px;
        }
    </style>
    <asp:HiddenField ID="accessToken" runat="server" />
    <asp:HiddenField ID="hdEmbedUrl" runat="server" />
    <asp:HiddenField ID="hdReportId" runat="server" />
    <asp:HiddenField ID="hdReportSection" runat="server" />
    <div ID="reportContainer" />
</asp:Content>
