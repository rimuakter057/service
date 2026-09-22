import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/common/cms_support/data/models/company_info_model.dart';
import 'package:nchito/features/common/cms_support/data/models/faq_model.dart';
import 'package:nchito/features/common/cms_support/domain/repositories/cms_support_repository.dart';
import 'package:nchito/features/common/cms_support/presentation/providers/company_notifier.dart';
import 'package:nchito/features/common/cms_support/presentation/providers/faq_notifier.dart';

class MockCmsSupportRepository implements CmsSupportRepository {
  final CompanyInfoModel companyInfo;
  final FaqListResponseModel faqResponse;

  MockCmsSupportRepository({
    required this.companyInfo,
    required this.faqResponse,
  });

  @override
  Future<CompanyInfoModel> getCompanyInfo({required bool isProvider}) async {
    return companyInfo;
  }

  @override
  Future<FaqListResponseModel> getFaqs({
    required bool isProvider,
    String? search,
    int? page,
    int? pageSize,
    String? ordering,
  }) async {
    if (search != null && search.isNotEmpty) {
      final filtered = faqResponse.items
          .where((item) =>
              item.question.toLowerCase().contains(search.toLowerCase()) ||
              item.answer.toLowerCase().contains(search.toLowerCase()))
          .toList();
      return FaqListResponseModel(
        success: true,
        count: filtered.length,
        items: filtered,
      );
    }
    return faqResponse;
  }
}

void main() {
  group('CompanyInfoModel & CompanyResponseModel', () {
    test('parses prompt and server JSON accurately', () {
      final sampleJson = {
        "success": true,
        "message": "Success",
        "data": {
          "id": "6a8eba5b341a31ddfd0cc8c4",
          "name": "Nchito",
          "business_type": "Online Service Marketplace Platform",
          "country": "Zambia",
          "tagline": "Find experts easily",
          "registration_number": "REG-12345",
          "tax_number": "TAX-9988",
          "address": "123 Great East Rd, Lusaka",
          "email": "support@nchito.com",
          "phone": "+260 97 123 4567",
          "website": "https://www.nchito.com",
          "facebook": "fb/nchito",
          "instagram": "ig/nchito",
          "twitter": "x/nchito",
          "app_version_android": "1.0.0",
          "app_version_ios": "1.0.0",
          "force_update": false
        }
      };

      final response = CompanyResponseModel.fromJson(sampleJson);
      expect(response.success, isTrue);
      expect(response.message, 'Success');
      expect(response.data.id, '6a8eba5b341a31ddfd0cc8c4');
      expect(response.data.name, 'Nchito');
      expect(response.data.businessType, 'Online Service Marketplace Platform');
      expect(response.data.country, 'Zambia');
      expect(response.data.email, 'support@nchito.com');
      expect(response.data.phone, '+260 97 123 4567');
      expect(response.data.website, 'https://www.nchito.com');
      expect(response.data.forceUpdate, isFalse);
    });
  });

  group('FaqModel & FaqListResponseModel', () {
    test('parses server FAQ JSON accurately', () {
      final sampleJson = {
        "success": true,
        "count": 3,
        "total_pages": 1,
        "current_page": 1,
        "page_size": 20,
        "next": null,
        "previous": null,
        "data": [
          {
            "id": "6a8eb72df3e0abf5ce27e3e2",
            "question": "How can I cancel a booking?",
            "answer": "Open the booking from My Bookings and tap Cancel Booking.",
            "category": "",
            "audience": "all",
            "audience_label": "Everyone",
            "sort_order": 2,
            "is_active": true
          }
        ]
      };

      final response = FaqListResponseModel.fromJson(sampleJson);
      expect(response.success, isTrue);
      expect(response.count, 3);
      expect(response.items.length, 1);
      expect(response.items.first.id, '6a8eb72df3e0abf5ce27e3e2');
      expect(response.items.first.question, 'How can I cancel a booking?');
      expect(response.items.first.audience, 'all');
      expect(response.items.first.isActive, isTrue);
    });
  });

  group('CompanyNotifier and ProviderCompanyNotifier', () {
    test('fetches and updates companyInfo', () async {
      const model = CompanyInfoModel(
        id: '123',
        name: 'Nchito Tech',
        businessType: 'Platform',
        country: 'Zambia',
      );
      final repo = MockCmsSupportRepository(
        companyInfo: model,
        faqResponse: const FaqListResponseModel(items: []),
      );

      final notifier = CompanyNotifier(repository: repo);
      expect(notifier.isLoading, isFalse);
      expect(notifier.companyInfo, isNull);

      await notifier.fetchCompanyInfo();
      expect(notifier.isLoading, isFalse);
      expect(notifier.companyInfo?.name, 'Nchito Tech');

      final providerNotifier = ProviderCompanyNotifier(repository: repo);
      await providerNotifier.fetchCompanyInfo();
      expect(providerNotifier.companyInfo?.name, 'Nchito Tech');
    });
  });

  group('FaqNotifier and ProviderFaqNotifier', () {
    test('fetches and filters FAQs', () async {
      const faq1 = FaqItemModel(
        id: 'faq1',
        question: 'How to book?',
        answer: 'Select a service and book.',
      );
      const faq2 = FaqItemModel(
        id: 'faq2',
        question: 'How to cancel?',
        answer: 'Go to bookings and tap cancel.',
      );

      final repo = MockCmsSupportRepository(
        companyInfo: const CompanyInfoModel(
          id: '1',
          name: 'Nchito',
          businessType: 'Marketplace',
          country: 'Zambia',
        ),
        faqResponse: const FaqListResponseModel(
          count: 2,
          items: [faq1, faq2],
        ),
      );

      final notifier = FaqNotifier(repository: repo);
      await notifier.fetchFaqs();
      expect(notifier.faqs.length, 2);

      await notifier.fetchFaqs(search: 'cancel');
      expect(notifier.faqs.length, 1);
      expect(notifier.faqs.first.id, 'faq2');
    });
  });
}
