enum MarketFailure { connection, server, unexpected }

class MarketRepositoryException implements Exception {
  final MarketFailure failure;
  final String? serverMessage;
  final int? code;

  const MarketRepositoryException(
    this.failure, {
    this.serverMessage,
    this.code,
  });
}
