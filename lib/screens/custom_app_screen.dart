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
  final _appNameController = TextEditingController(text: 'companion');
  final _durationController = TextEditingController();
  final _iconController = TextEditingController(text: '230');
  Color _selectedColor = Colors.white;
  bool _useDuration = false;

  @override
  void dispose() {
    _textController.dispose();
    _appNameController.dispose();
    _durationController.dispose();
    _iconController.dispose();
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

    try {
      final icon = int.tryParse(_iconController.text);
      final duration = _useDuration
          ? int.tryParse(_durationController.text)
          : null;

      await widget.awtrixService!.sendCustomApp(
        appName: _appNameController.text,
        text: _textController.text,
        icon: icon,
        duration: duration,
        textColor: _selectedColor,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message envoyé avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _deleteMessage() async {
    if (widget.awtrixService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service AWTRIX non disponible')),
      );
      return;
    }

    // Confirmation avant suppression
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'app'),
        content: Text(
          'Voulez-vous vraiment supprimer l\'app "${_appNameController.text}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await widget.awtrixService!.deleteCustomApp(_appNameController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App supprimée avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
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

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                    _buildIconOption(230, '❤️ Coeur'),
                    _buildIconOption(1486, '📧 Email'),
                    _buildIconOption(982, '☀️ Soleil'),
                    _buildIconOption(2286, '🌙 Lune'),
                    _buildIconOption(1465, '✓ Check'),
                    _buildIconOption(1468, '✗ Croix'),
                    _buildIconOption(1572, '⚠️ Alerte'),
                    _buildIconOption(7956, '🔔 Cloche'),
                    _buildIconOption(1558, '⭐ Étoile'),
                    _buildIconOption(2355, '🏠 Maison'),
                    _buildIconOption(1485, '💡 Ampoule'),
                    _buildIconOption(1247, '🎵 Musique'),
                  ],
                ),
              ),
            ],
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

  Widget _buildIconOption(int iconId, String label) {
    final isSelected = _iconController.text == iconId.toString();
    return InkWell(
      onTap: () {
        setState(() {
          _iconController.text = iconId.toString();
        });
        Navigator.of(context).pop();
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
        title: const Text('Messages personnalisés'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nom de l'app
              TextFormField(
                controller: _appNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'app',
                  hintText: 'companion',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'app';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Texte du message
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Texte',
                  hintText: 'Entrez votre message',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.text_fields),
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

              // Durée
              SwitchListTile(
                title: const Text('Durée spécifique'),
                subtitle: const Text(
                  'Afficher le message pendant une durée limitée',
                ),
                value: _useDuration,
                onChanged: (value) {
                  setState(() => _useDuration = value);
                },
                tileColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              if (_useDuration) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Durée (secondes)',
                    hintText: '10',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (_useDuration && (value == null || value.isEmpty)) {
                      return 'Veuillez entrer une durée';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 32),

              // Bouton d'envoi
              ElevatedButton.icon(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                label: const Text('Envoyer le message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Bouton de suppression
              OutlinedButton.icon(
                onPressed: _deleteMessage,
                icon: const Icon(Icons.delete),
                label: const Text('Supprimer l\'app'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
