// lib/widgets/chatoshi_search_modal.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/app_colors.dart';

/// Displays the Chatoshi AI modal with a blurred background.
void showChatoshiSearchModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) => const ChatoshiSearchModal(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
  );
}

class ChatoshiSearchModal extends StatefulWidget {
  // TODO: Add your real partner key here when you get it from Chatoshi
  final String partnerKey;

  const ChatoshiSearchModal({
    Key? key,
    this.partnerKey = 'your-partner-key', 
  }) : super(key: key);

  @override
  State<ChatoshiSearchModal> createState() => _ChatoshiSearchModalState();
}

class _ChatoshiSearchModalState extends State<ChatoshiSearchModal> {
  late WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // The HTML payload that mounts the Chatoshi SDK
    final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        body, html { 
          margin: 0; 
          padding: 0; 
          height: 100%; 
          width: 100%; 
          background-color: #121212; /* Matches AppColors.offBlack */
          color: white;
          overflow: hidden;
        }
        #chat-container { 
          width: 100%; 
          height: 100%; 
        }
        .loader {
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100%;
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
          color: #FBC02D; /* Matches Cabal Gold */
        }
      </style>
      
      <!-- TODO: Replace "example.com" with the actual Chatoshi CDN URL -->
      <script src="https://example.com/chatoshi-sdk.js"></script>
    </head>
    <body>
      <div id="chat-container">
        <div class="loader">Initializing Chatoshi AI...</div>
      </div>
      
      <script>
        window.onload = function() {
          try {
            if (typeof Chatoshi !== 'undefined') {
              // Clear the loader text
              document.getElementById('chat-container').innerHTML = '';
              
              // Initialize the SDK
              const chat = new Chatoshi({
                partnerKey: '${widget.partnerKey}',
                container: '#chat-container',
                mode: 'embedded' // "embedded" mode is best inside a WebView wrapper
              });

              chat.on('app:ready', () => {
                console.log('Chatoshi AI web3 assistant is ready!');
              });
            } else {
              document.getElementById('chat-container').innerHTML = '<div class="loader">Failed to load Chatoshi SDK. Check network or URL.</div>';
            }
          } catch(e) {
             document.getElementById('chat-container').innerHTML = '<div class="loader">Error starting AI: ' + e.message + '</div>';
          }
        };
      </script>
    </body>
    </html>
    ''';

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.offBlack)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Chatoshi SDK WebView Error: \${error.description}");
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 20,
          color: AppColors.offBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.darkGrey),
          ),
          child: Container(
            margin: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(maxWidth: 700),
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children:[
                // Cabal Native Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children:[
                      const FaIcon(FontAwesomeIcons.robot, size: 20, color: AppColors.gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Chatoshi AI Copilot",
                          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: "Close",
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.darkGrey),
                
                // The WebView containing the injected Chatoshi SDK
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Stack(
                      children:[
                        WebViewWidget(controller: _webViewController),
                        
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(color: AppColors.gold),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
