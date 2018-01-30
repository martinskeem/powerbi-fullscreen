<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PowerBiFullScreen.Default" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="scripts/powerbi.js"></script>

    <script type="text/javascript">
        var d;

        window.onload = function () {
            var accessToken = document.getElementById('MainContent_accessToken').value;

            if (!accessToken || accessToken == "") {
                return;
            }

            var embedUrl = document.getElementById('MainContent_hdEmbedUrl').value;
            var container = document.getElementById('container');
            var interval = document.getElementById('MainContent_hdRefreshIntervalMinutes').value * 60 * 1000;
            var contentType = document.getElementById('MainContent_hdContentType').value;

            if (contentType == "report") {
                embedReport(accessToken, embedUrl, container, interval);
            } else if (contentType == "dashboard") {
                embedDashboard(accessToken, embedUrl, container, interval);
            }
        };

        function embedDashboard(accessToken, embedUrl, container, interval) {
            console.info("embedDashboard");

            var config = {
                type: 'dashboard',
                accessToken: accessToken,
                embedUrl: embedUrl
            }

            d = powerbi.embed(container, config);

            if (interval > 0) {
                window.setInterval(
                    function () {
                        if (d != null) {
                            d.reload();
                            console.info("Dashboard reloaded");
                        }
                    },
                    interval);
            }            
        }

        function embedReport(accessToken, embedUrl, container, interval) {
            console.info("embedReport");

            var reportSection = document.getElementById('MainContent_hdReportSection').value;

            var config = {
                type: 'report',
                accessToken: accessToken,
                embedUrl: embedUrl,
                pageName: reportSection,
                settings: {
                    filterPaneEnabled: false,
                    navContentPaneEnabled: false
                }
            };

            var r = powerbi.embed(container, config);

            if (interval > 0) {
                window.setInterval(
                    function () {
                        if (r != null) {
                            r.refresh();
                            console.info("Report reloaded");
                        }
                    },
                    interval);
            }
        }

    </script>

    <style>
        #container {
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
    <asp:HiddenField ID="hdReportSection" runat="server" />
    <asp:HiddenField ID="hdRefreshIntervalMinutes" runat="server" />
    <asp:HiddenField ID="hdContentType" runat="server" />
    <div ID="container" />
</asp:Content>