import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../services/awtrix_service.dart';

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
  Color _selectedColor = Colors.white;
  Color? _backgroundColor;
  bool _useRainbow = false;
  bool _useBackground = false;
  String? _selectedOverlay;

  @override
  void dispose() {
    _textController.dispose();
    _durationController.dispose();
    _iconController.dispose();
    _blinkTextController.dispose();
    _fadeTextController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.awtrixService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service AWTRIX non disponible')),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    try {
      final icon = int.tryParse(_iconController.text);
      final duration = int.tryParse(_durationController.text);
      final blinkText = _blinkTextController.text.isNotEmpty
          ? int.tryParse(_blinkTextController.text)
          : null;
      final fadeText = _fadeTextController.text.isNotEmpty
          ? int.tryParse(_fadeTextController.text)
          : null;

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
          const SnackBar(
            content: Text('Notification envoyée avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _downloadIcon(BuildContext dialogContext, int iconId) async {
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
            content: Text('Icône $iconId téléchargée et uploadée!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Fermer le dialogue de progression
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Couleur du texte'),
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
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showBackgroundColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Couleur de fond'),
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
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Choisir une icône'),
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
                              'Les icônes proviennent de LaMetric',
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
                        'Visitez https://developer.lametric.com/icons pour parcourir toutes les icônes disponibles et trouver leur ID.',
                        style: TextStyle(
                          color: Colors.blue.shade200,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Icônes populaires :',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                      _buildIconOption(230, '❤️ Coeur', setDialogState),
                      _buildIconOption(1486, '📧 Email', setDialogState),
                      _buildIconOption(982, '☀️ Soleil', setDialogState),
                      _buildIconOption(2286, '🌙 Lune', setDialogState),
                      _buildIconOption(1465, '✓ Check', setDialogState),
                      _buildIconOption(1468, '✗ Croix', setDialogState),
                      _buildIconOption(1572, '⚠️ Alerte', setDialogState),
                      _buildIconOption(7956, '🔔 Cloche', setDialogState),
                      _buildIconOption(1558, '⭐ Étoile', setDialogState),
                      _buildIconOption(2355, '🏠 Maison', setDialogState),
                      _buildIconOption(1485, '💡 Ampoule', setDialogState),
                      _buildIconOption(1247, '🎵 Musique', setDialogState),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton.icon(
              onPressed: () async {
                final iconId = int.tryParse(_iconController.text);
                if (iconId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez entrer un ID d\'icône valide'),
                    ),
                  );
                  return;
                }

                // Fermer le dialogue de sélection d'icônes
                Navigator.of(context).pop();

                // Afficher un dialogue de progression
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    // Lancer le téléchargement avec le contexte du dialogue
                    _downloadIcon(dialogContext, iconId);
                    return const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Téléchargement de l\'icône...'),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Télécharger'),
            ),
            ElevatedButton(
              onPressed: () {
                // Simplement fermer le dialogue avec l'icône sélectionnée
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sélectionner'),
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Texte de la notification
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Entrez le texte de votre notification',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un texte';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Icône
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _iconController,
                      decoration: const InputDecoration(
                        labelText: 'Icône (ID)',
                        hintText: '230',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.emoji_emotions),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showIconPicker,
                    icon: const Icon(Icons.search),
                    tooltip: 'Choisir une icône',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Couleur du texte
              ListTile(
                title: const Text('Couleur du texte'),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),

              // Section Effets de texte
              const Text(
                'Effets de texte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Blink Text
              TextFormField(
                controller: _blinkTextController,
                decoration: const InputDecoration(
                  labelText: 'Clignotement (ms)',
                  hintText: '500',
                  helperText: 'Intervalle de clignotement en millisecondes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flash_on),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),

              // Fade Text
              TextFormField(
                controller: _fadeTextController,
                decoration: const InputDecoration(
                  labelText: 'Fondu (ms)',
                  hintText: '1000',
                  helperText: 'Intervalle de fondu en millisecondes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.blur_on),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),

              // Rainbow effect
              SwitchListTile(
                title: const Text('Effet arc-en-ciel'),
                subtitle: const Text(
                  'Fait défiler chaque lettre à travers le spectre RGB',
                ),
                value: _useRainbow,
                onChanged: (value) {
                  setState(() => _useRainbow = value);
                },
                tileColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),

              // Background color
              SwitchListTile(
                title: const Text('Couleur de fond'),
                subtitle: const Text(
                  'Définir une couleur de fond personnalisée',
                ),
                value: _useBackground,
                onChanged: (value) {
                  setState(() => _useBackground = value);
                },
                tileColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              if (_useBackground) ...[
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Choisir la couleur de fond'),
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
              const SizedBox(height: 16),

              // Overlay effects
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Effet de superposition',
                  helperText: 'Ajoute un effet visuel par-dessus le texte',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.layers),
                ),
                initialValue: _selectedOverlay,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Aucun')),
                  DropdownMenuItem(value: 'clear', child: Text('🌤️ Clear')),
                  DropdownMenuItem(value: 'snow', child: Text('❄️ Snow')),
                  DropdownMenuItem(value: 'rain', child: Text('🌧️ Rain')),
                  DropdownMenuItem(
                    value: 'drizzle',
                    child: Text('🌦️ Drizzle'),
                  ),
                  DropdownMenuItem(value: 'storm', child: Text('⛈️ Storm')),
                  DropdownMenuItem(value: 'thunder', child: Text('⚡ Thunder')),
                  DropdownMenuItem(value: 'frost', child: Text('🧊 Frost')),
                ],
                onChanged: (value) {
                  setState(() => _selectedOverlay = value);
                },
              ),
              const SizedBox(height: 16),

              // Durée
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Durée (secondes)',
                  hintText: '5',
                  helperText:
                      'Durée d\'affichage de la notification (défaut: 5s)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une durée';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration < 1) {
                    return 'La durée doit être au moins 1 seconde';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendMessage,
        icon: const Icon(Icons.send),
        label: const Text('Envoyer'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
    );
  }
}
