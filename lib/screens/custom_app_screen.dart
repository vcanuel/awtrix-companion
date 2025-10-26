import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../services/awtrix_service.dart';
import '../l10n/app_localizations.dart';

class CustomAppScreen extends StatefulWidget {
  final AwtrixService? awtrixService;

  const CustomAppScreen({super.key, this.awtrixService});

  @override
  State<CustomAppScreen> createState() => _CustomAppScreenState();
}

class _CustomAppScreenState extends State<CustomAppScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _durationController = TextEditingController(text: '5');
  final _iconController = TextEditingController(text: '230');
  final _blinkTextController = TextEditingController();
  final _fadeTextController = TextEditingController();
  final _appNameController = TextEditingController(text: 'companion');
  Color _selectedColor = Colors.white;
  Color? _backgroundColor;
  bool _useRainbow = false;
  bool _useBackground = false;
  bool _sendAsApp = false;
  String? _selectedOverlay;

  @override
  void dispose() {
    _textController.dispose();
    _durationController.dispose();
    _iconController.dispose();
    _blinkTextController.dispose();
    _fadeTextController.dispose();
    _appNameController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.awtrixService == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.awtrixServiceUnavailable)));
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    try {
      final icon = int.tryParse(_iconController.text);
      final blinkText = _blinkTextController.text.isNotEmpty
          ? int.tryParse(_blinkTextController.text)
          : null;
      final fadeText = _fadeTextController.text.isNotEmpty
          ? int.tryParse(_fadeTextController.text)
          : null;

      if (_sendAsApp) {
        // Envoyer en tant qu'app personnalisée via api/custom
        await widget.awtrixService!.sendCustomApp(
          appName: _appNameController.text,
          text: _textController.text,
          icon: icon,
          textColor: _selectedColor,
          blinkText: blinkText,
          fadeText: fadeText,
          background: _useBackground ? _backgroundColor : null,
          rainbow: _useRainbow,
          overlay: _selectedOverlay,
        );

        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.appCreated(_appNameController.text)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Envoyer en tant que notification via api/notify
        final duration = int.tryParse(_durationController.text);

        await widget.awtrixService!.sendNotification(
          text: _textController.text,
          icon: icon,
          duration: duration,
          textColor: _selectedColor,
          blinkText: blinkText,
          fadeText: fadeText,
          background: _useBackground ? _backgroundColor : null,
          rainbow: _useRainbow,
          overlay: _selectedOverlay,
        );

        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.notificationSent),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.error(e.toString()))),
        );
      }
    }
  }

  Future<void> _downloadIcon(BuildContext dialogContext, int iconId) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(dialogContext);

    try {
      if (widget.awtrixService != null) {
        await widget.awtrixService!.downloadLaMetricIcon(iconId);

        if (!mounted) return;
        // Fermer le dialogue de progression
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.iconDownloaded(iconId)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Fermer le dialogue de progression
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
    }
  }

  void _showColorPicker() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.textColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() => _selectedColor = color);
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showBackgroundColorPicker() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.backgroundColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _backgroundColor ?? Colors.black,
            onColorChanged: (color) {
              setState(() => _backgroundColor = color);
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        labelText: l10n.message,
        hintText: l10n.enterText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.message),
      ),
      maxLines: 3,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterText;
        }
        return null;
      },
    );
  }

  Widget _buildSendAsAppToggle() {
    final l10n = AppLocalizations.of(context)!;
    return SwitchListTile(
      title: Text(l10n.sendAsApp),
      subtitle: Text(l10n.sendAsAppDescription),
      value: _sendAsApp,
      onChanged: (value) {
        setState(() => _sendAsApp = value);
      },
      tileColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildAppNameField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _appNameController,
      decoration: InputDecoration(
        labelText: l10n.appName,
        hintText: l10n.appNameDefault,
        helperText: l10n.appNameHelper,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.label),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterAppName;
        }
        return null;
      },
    );
  }

  Widget _buildIconField() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _iconController,
            decoration: InputDecoration(
              labelText: l10n.iconId,
              hintText: '230',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.emoji_emotions),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _showIconPicker,
          icon: const Icon(Icons.search),
          tooltip: l10n.chooseIcon,
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildTextColorPicker() {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(l10n.textColor),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _selectedColor,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTap: _showColorPicker,
      tileColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildTextEffectsSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.textEffects,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _blinkTextController,
          decoration: InputDecoration(
            labelText: l10n.blink,
            hintText: '500',
            helperText: l10n.blinkHelper,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.flash_on),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fadeTextController,
          decoration: InputDecoration(
            labelText: l10n.fade,
            hintText: '1000',
            helperText: l10n.fadeHelper,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.blur_on),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildRainbowToggle() {
    final l10n = AppLocalizations.of(context)!;
    return SwitchListTile(
      title: Text(l10n.rainbowEffect),
      subtitle: Text(l10n.rainbowEffectDescription),
      value: _useRainbow,
      onChanged: (value) {
        setState(() => _useRainbow = value);
      },
      tileColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildBackgroundColorSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.backgroundColor),
          subtitle: Text(l10n.backgroundColorDescription),
          value: _useBackground,
          onChanged: (value) {
            setState(() => _useBackground = value);
          },
          tileColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        if (_useBackground) ...[
          const SizedBox(height: 8),
          ListTile(
            title: Text(l10n.chooseBackgroundColor),
            trailing: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _backgroundColor ?? Colors.black,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: _showBackgroundColorPicker,
            tileColor: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOverlayDropdown() {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: l10n.overlayEffect,
        helperText: l10n.overlayEffectHelper,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.layers),
      ),
      initialValue: _selectedOverlay,
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.none)),
        const DropdownMenuItem(value: 'clear', child: Text('🌤️ Clear')),
        const DropdownMenuItem(value: 'snow', child: Text('❄️ Snow')),
        const DropdownMenuItem(value: 'rain', child: Text('🌧️ Rain')),
        const DropdownMenuItem(value: 'drizzle', child: Text('🌦️ Drizzle')),
        const DropdownMenuItem(value: 'storm', child: Text('⛈️ Storm')),
        const DropdownMenuItem(value: 'thunder', child: Text('⚡ Thunder')),
        const DropdownMenuItem(value: 'frost', child: Text('🧊 Frost')),
      ],
      onChanged: (value) {
        setState(() => _selectedOverlay = value);
      },
    );
  }

  Widget _buildDurationField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _durationController,
      decoration: InputDecoration(
        labelText: l10n.duration,
        hintText: l10n.durationDefault,
        helperText: l10n.durationHelper,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.timer),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterDuration;
        }
        final duration = int.tryParse(value);
        if (duration == null || duration < 1) {
          return l10n.durationMinimum;
        }
        return null;
      },
    );
  }

  void _showIconPicker() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.chooseIcon),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900.withAlpha((0.3 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade300),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.iconsFromLaMetric,
                              style: TextStyle(
                                color: Colors.blue.shade100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.visitLaMetricIcons,
                        style: TextStyle(
                          color: Colors.blue.shade200,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.popularIcons,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildIconOption(230, '❤️ ${l10n.heart}', setDialogState),
                      _buildIconOption(
                        1486,
                        '📧 ${l10n.email}',
                        setDialogState,
                      ),
                      _buildIconOption(982, '☀️ ${l10n.sun}', setDialogState),
                      _buildIconOption(2286, '🌙 ${l10n.moon}', setDialogState),
                      _buildIconOption(1465, '✓ ${l10n.check}', setDialogState),
                      _buildIconOption(1468, '✗ ${l10n.cross}', setDialogState),
                      _buildIconOption(
                        1572,
                        '⚠️ ${l10n.alert}',
                        setDialogState,
                      ),
                      _buildIconOption(7956, '🔔 ${l10n.bell}', setDialogState),
                      _buildIconOption(1558, '⭐ ${l10n.star}', setDialogState),
                      _buildIconOption(2355, '🏠 ${l10n.home}', setDialogState),
                      _buildIconOption(1485, '💡 ${l10n.bulb}', setDialogState),
                      _buildIconOption(
                        1247,
                        '🎵 ${l10n.music}',
                        setDialogState,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton.icon(
              onPressed: () async {
                final iconId = int.tryParse(_iconController.text);
                if (iconId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.pleaseEnterValidIconId)),
                  );
                  return;
                }

                // Close icon selection dialog
                Navigator.of(context).pop();

                // Show progress dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    // Start download with dialog context
                    _downloadIcon(dialogContext, iconId);
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(l10n.downloadingIcon),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.download),
              label: Text(l10n.download),
            ),
            ElevatedButton(
              onPressed: () {
                // Simply close dialog with selected icon
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.select),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconOption(
    int iconId,
    String label,
    StateSetter setDialogState,
  ) {
    final isSelected = _iconController.text == iconId.toString();
    return InkWell(
      onTap: () {
        setDialogState(() {
          _iconController.text = iconId.toString();
        });
        // Ne pas fermer le dialogue, permettre de télécharger après sélection
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepOrange.withAlpha(51)
              : Colors.grey.shade900,
          border: Border.all(
            color: isSelected ? Colors.deepOrange : Colors.grey.shade700,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label.split(' ')[0], style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              iconId.toString(),
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.deepOrange : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              label.substring(label.indexOf(' ') + 1),
              style: const TextStyle(fontSize: 9),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: GestureDetector(
            onTap: () {
              // Close keyboard when tapping outside text field
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMessageField(),
                    const SizedBox(height: 16),
                    _buildSendAsAppToggle(),
                    const SizedBox(height: 16),
                    if (_sendAsApp) ...[
                      _buildAppNameField(),
                      const SizedBox(height: 16),
                    ],
                    _buildIconField(),
                    const SizedBox(height: 16),
                    _buildTextColorPicker(),
                    const SizedBox(height: 16),
                    _buildTextEffectsSection(),
                    const SizedBox(height: 16),
                    _buildRainbowToggle(),
                    const SizedBox(height: 16),
                    _buildBackgroundColorSection(),
                    const SizedBox(height: 16),
                    _buildOverlayDropdown(),
                    const SizedBox(height: 16),
                    if (!_sendAsApp) ...[
                      _buildDurationField(),
                      const SizedBox(height: 32),
                    ] else ...[
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            label: Text(l10n.send),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
