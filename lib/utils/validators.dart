class Validators {
  /// Valida se um campo obrigatório não está nulo ou vazio.
  static String? obrigatorio(String? value, {String campo = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$campo é obrigatório.';
    }
    return null;
  }

  /// Valida se o e-mail é obrigatório e possui um formato válido.
  static String? email(String? value) {
    final erroObrigatorio = obrigatorio(value, campo: 'E-mail');
    if (erroObrigatorio != null) return erroObrigatorio;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  /// Valida se o telefone é obrigatório e possui 10 ou 11 dígitos numéricos.
  static String? telefone(String? value) {
    final erroObrigatorio = obrigatorio(value, campo: 'Telefone');
    if (erroObrigatorio != null) return erroObrigatorio;

    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) {
      return 'Informe um telefone válido (10 ou 11 dígitos).';
    }

    return null;
  }

  /// Checa se o formato do CEP contém exatamente 8 dígitos numéricos.
  static bool cepEhValido(String cep) {
    final digits = cep.replaceAll(RegExp(r'\D'), '');
    return digits.length == 8;
  }

  /// Valida se o CEP é obrigatório e possui exatamente 8 dígitos.
  static String? cep(String? value) {
    final erroObrigatorio = obrigatorio(value, campo: 'CEP');
    if (erroObrigatorio != null) return erroObrigatorio;

    if (!cepEhValido(value!)) {
      return 'CEP inválido — deve conter 8 dígitos.';
    }

    return null;
  }
}
