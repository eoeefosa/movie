import 'package:movieboxclone/Commerce/models.dart/cartegory.dart';
import 'package:movieboxclone/api/api_calls/commerce.dart';
import 'package:test/test.dart';

void main() {
  test('Api should return', () async {
    final commercereApi = CommerceApi();

    final result= await commercereApi.getCartegories();
    print(result);

      // Act

      // Assert
      expect(result, isA<List>());
      if (result.isNotEmpty) {
        expect(result[0], isA<Categories>());
      }

    expect(result, {});
  });
}
