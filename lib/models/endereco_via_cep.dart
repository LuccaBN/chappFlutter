class EnderecoViaCep {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;

  EnderecoViaCep({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  /// Cria uma instância de [EnderecoViaCep] a partir de um [Map] decodificado do JSON retornado pelo ViaCEP.
  factory EnderecoViaCep.fromJson(Map<String, dynamic> json) {
    return EnderecoViaCep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}
