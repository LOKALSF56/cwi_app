import 'package:appwrite/appwrite.dart';
import '../config/environment.dart';

class AppwriteService {
  static final Client client = Client()
      .setEndpoint(Environment.appwriteEndpoint)
      .setProject(Environment.appwriteProjectId)
      .setSelfSigned(status: true); // hanya untuk dev

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Storage storage = Storage(client);
}
