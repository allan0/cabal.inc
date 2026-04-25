// lib/widgets/post_card_widget.dart
import 'package:cabal/models/user_profile_model.dart';
import '../screens/login_screen.dart';
import '../screens/post_detail_screen.dart';
import '../services/supabase_service.dart';
import '../services/web3_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../models/community_post_model.dart';
import '../utils/app_colors.dart';

class PostCardWidget extends StatefulWidget {
  final CommunityPost post;
  final UserProfile? currentUserProfile;
  final bool isDetailView; // Prevents navigating to detail from detail screen

  const PostCardWidget({
    Key? key,
    required this.post,
    this.currentUserProfile,
    this.isDetailView = false,
  }) : super(key: key);

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  final SupabaseService _supabaseService = SupabaseService();
  late bool _isLiked;
  late int _likeCount;
  late int _commentCount;
  bool _isLiking = false;
  bool _isTipping = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLikedByUser;
    _likeCount = widget.post.likes;
    _commentCount = widget.post.commentCount;
  }

  Future<void> _toggleLike() async {
    if (widget.currentUserProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to like posts.')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      final result = await _supabaseService.toggleLike(widget.post.id);
      if (mounted) {
        setState(() {
          widget.post.updateFromToggleLike(result);
          _isLiked = widget.post.isLikedByUser;
          _likeCount = widget.post.likes;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likeCount += _isLiked ? 1 : -1;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }
  
  Future<void> _handleTipCreator() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet to tip.")));
        await walletProvider.connectEVMWallet(context: context);
        return;
    }

    if (widget.currentUserProfile?.id == widget.post.userId) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("You cannot tip yourself.")));
      return;
    }
    
    final tipAmountStr = await showDialog<String>(
      context: context, 
      builder: (context) => const TipAmountDialog()
    );

    if (tipAmountStr == null || tipAmountStr.trim().isEmpty) return;
    final tipAmountDouble = double.tryParse(tipAmountStr);
    if (tipAmountDouble == null || tipAmountDouble <= 0) return;

    setState(() => _isTipping = true);

    try {
      final authorProfile = await supabaseService.getUserProfile(widget.post.userId);
      final recipientAddress = authorProfile?.connectedWallets['evm'];

      if (recipientAddress == null || recipientAddress.isEmpty) {
        throw Exception("${widget.post.authorName} has not connected a wallet to receive tips.");
      }

      final amountInWei = BigInt.from(tipAmountDouble * 1e18);

      final tx = web3Service.buildTipUserTransaction(
        recipientAddress: recipientAddress,
        amountInCblWei: amountInWei,
      );
      
      final txHash = await walletProvider.sendTransaction(tx);
      
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Successfully tipped ${widget.post.authorName}! Tx: $txHash"),
        backgroundColor: AppColors.success,
      ));

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Tip failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isTipping = false);
    }
  }

  void _navigateToDetail() {
    if (widget.isDetailView) return;
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: PostDetailScreen(
          post: widget.post,
          currentUserProfile: widget.currentUserProfile,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _commentCount = widget.post.commentCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: _navigateToDetail,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 12),
              Text(widget.post.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.4)),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: widget.post.authorAvatarUrl.isNotEmpty
              ? NetworkImage(widget.post.authorAvatarUrl)
              : null,
          child: widget.post.authorAvatarUrl.isEmpty
              ? const FaIcon(FontAwesomeIcons.userAstronaut, size: 20)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.post.authorName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(widget.post.timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
            ],
          ),
        ),
        if (!widget.isDetailView)
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz, color: theme.iconTheme.color?.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final likeColor = _isLiked ? AppColors.error : theme.textTheme.bodyMedium?.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: _toggleLike,
              icon: _isLiking
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : FaIcon(
                      _isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                      size: 16,
                      color: likeColor,
                    ).animate(target: _isLiked ? 1 : 0).shake(hz: 4, duration: 200.ms),
              label: Text(_likeCount.toString(), style: TextStyle(color: likeColor)),
              style: TextButton.styleFrom(foregroundColor: theme.textTheme.bodyMedium?.color),
            ),
            TextButton.icon(
              onPressed: _navigateToDetail,
              icon: const FaIcon(FontAwesomeIcons.solidComment, size: 16),
              label: Text(_commentCount.toString()),
              style: TextButton.styleFrom(foregroundColor: theme.textTheme.bodyMedium?.color),
            ),
            if (widget.currentUserProfile != null)
              TextButton.icon(
                onPressed: _isTipping ? null : _handleTipCreator,
                icon: _isTipping 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const FaIcon(FontAwesomeIcons.coins, size: 16, color: AppColors.gold),
                label: const Text("Tip"),
                style: TextButton.styleFrom(foregroundColor: AppColors.gold),
              ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined, size: 20),
        ),
      ],
    );
  }
}

class TipAmountDialog extends StatefulWidget {
  const TipAmountDialog({Key? key}) : super(key: key);

  @override
  State<TipAmountDialog> createState() => _TipAmountDialogState();
}

class _TipAmountDialogState extends State<TipAmountDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tip Creator with \$CBL'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          decoration: const InputDecoration(
            labelText: 'Amount',
            suffixText: '\$CBL',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter an amount.';
            final amount = double.tryParse(value);
            if (amount == null) return 'Please enter a valid number.';
            if (amount <= 0) return 'Amount must be greater than zero.';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('Send Tip'),
        )
      ],
    );
  }
}
