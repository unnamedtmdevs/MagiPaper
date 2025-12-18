//
//  Article.swift
//  MagiPaper
//

import Foundation

struct Article: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let content: String
    let category: Category
    let imageURL: String?
    let publishedDate: Date
    let source: String
    let author: String
    let readingTime: Int // in minutes
    let tags: [String]
    var isFavorite: Bool
    
    enum Category: String, Codable, CaseIterable {
        case technology = "Technology"
        case business = "Business"
        case science = "Science"
        case entertainment = "Entertainment"
        case sports = "Sports"
        case health = "Health"
        case politics = "Politics"
        case travel = "Travel"
        case lifestyle = "Lifestyle"
        case culture = "Culture"
        
        var displayName: String {
            self.rawValue
        }
        
        var icon: String {
            switch self {
            case .technology: return "cpu"
            case .business: return "briefcase.fill"
            case .science: return "flask.fill"
            case .entertainment: return "film.fill"
            case .sports: return "sportscourt.fill"
            case .health: return "heart.fill"
            case .politics: return "building.columns.fill"
            case .travel: return "airplane"
            case .lifestyle: return "star.fill"
            case .culture: return "theatermasks.fill"
            }
        }
    }
    
    init(id: UUID = UUID(),
         title: String,
         summary: String,
         content: String,
         category: Category,
         imageURL: String? = nil,
         publishedDate: Date = Date(),
         source: String,
         author: String,
         readingTime: Int,
         tags: [String] = [],
         isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.category = category
        self.imageURL = imageURL
        self.publishedDate = publishedDate
        self.source = source
        self.author = author
        self.readingTime = readingTime
        self.tags = tags
        self.isFavorite = isFavorite
    }
}

// MARK: - Sample Data
extension Article {
    static var sampleArticles: [Article] {
        [
            Article(
                title: "The Future of Quantum Computing",
                summary: "Researchers make breakthrough in quantum error correction, bringing practical quantum computers closer to reality.",
                content: """
                In a groundbreaking development, researchers at leading tech institutions have achieved a significant milestone in quantum error correction, a critical component for building practical quantum computers.
                
                The team demonstrated a new approach that reduces error rates by 99.9%, making quantum computers more stable and reliable for real-world applications. This advancement could revolutionize fields from cryptography to drug discovery.
                
                "This is a watershed moment for quantum computing," says Dr. Sarah Chen, lead researcher on the project. "We've overcome one of the most significant barriers to scaling quantum systems."
                
                The implications are far-reaching. Financial institutions are already exploring how quantum computing could optimize trading strategies and risk assessment. Pharmaceutical companies see potential for accelerating drug discovery by simulating molecular interactions at unprecedented scales.
                
                However, challenges remain. The technology requires extremely cold temperatures and sophisticated isolation from environmental interference. Commercial applications may still be years away, but this breakthrough marks a crucial step forward.
                
                Industry experts predict that within the next decade, we could see quantum computers tackling problems that are impossible for classical computers, from climate modeling to artificial intelligence advancement.
                """,
                category: .technology,
                imageURL: "quantum.computing.image",
                source: "Tech Innovations Weekly",
                author: "Michael Rivers",
                readingTime: 5,
                tags: ["Quantum", "Computing", "Innovation", "Science"]
            ),
            Article(
                title: "Global Markets React to New Economic Policies",
                summary: "Stock markets worldwide show mixed responses to coordinated central bank policy changes.",
                content: """
                Financial markets around the globe experienced significant volatility today as major central banks announced coordinated policy adjustments aimed at balancing economic growth with inflation concerns.
                
                The Federal Reserve, European Central Bank, and Bank of Japan simultaneously released statements outlining their strategic approaches for the coming quarter. The synchronized messaging represents an unprecedented level of international cooperation.
                
                Asian markets opened with cautious optimism, with the Nikkei gaining 2.3% in early trading. European indices showed more mixed results, with the FTSE rising 0.8% while the DAX remained relatively flat.
                
                Analysts point to several factors driving market uncertainty. Supply chain disruptions continue to impact manufacturing sectors, while energy prices remain elevated. However, strong consumer spending data suggests underlying economic resilience.
                
                "We're seeing a complex interplay of factors," notes Elizabeth Martinez, chief economist at Global Financial Insights. "The central banks are trying to thread the needle between supporting growth and containing inflation."
                
                Technology stocks led gains in most markets, buoyed by strong earnings reports from major players. The semiconductor sector showed particular strength, reflecting continued demand for chips across industries.
                
                Looking ahead, investors are watching for additional policy signals and economic data that could influence market direction. Currency markets also showed movement, with the dollar strengthening against most major currencies.
                """,
                category: .business,
                source: "Financial Times International",
                author: "Robert Chen",
                readingTime: 4,
                tags: ["Finance", "Markets", "Economy", "Policy"]
            ),
            Article(
                title: "Revolutionary Cancer Treatment Shows Promise",
                summary: "New immunotherapy approach demonstrates remarkable success in clinical trials for previously untreatable cancers.",
                content: """
                A revolutionary cancer treatment using engineered immune cells has shown unprecedented success in late-stage clinical trials, offering hope for patients with previously untreatable forms of the disease.
                
                The therapy, which modifies a patient's own T-cells to recognize and attack cancer cells, achieved complete remission in 72% of participants with aggressive lymphomas that had resisted all other treatments.
                
                "These results exceed our most optimistic projections," says Dr. Amanda Foster, principal investigator of the study. "We're witnessing responses in patients who had exhausted all other options."
                
                The treatment works by extracting immune cells from patients, genetically engineering them to express receptors that target specific cancer markers, then reinfusing them into the body. The modified cells multiply and mount a sustained attack on tumors.
                
                Unlike traditional chemotherapy, which affects both healthy and cancerous cells, this approach is highly targeted. Patients reported fewer side effects and better quality of life during treatment.
                
                The breakthrough builds on decades of immunotherapy research and recent advances in genetic engineering. Regulatory authorities are fast-tracking review processes, with approval decisions expected within months.
                
                Cost remains a concern, as the personalized nature of the treatment makes it expensive to produce. However, researchers are working on streamlined manufacturing processes that could make it more accessible.
                
                Patient advocacy groups have hailed the development as a turning point in cancer care, potentially transforming outcomes for thousands of patients annually.
                """,
                category: .health,
                source: "Medical Science Today",
                author: "Dr. James Wilson",
                readingTime: 6,
                tags: ["Health", "Cancer", "Medicine", "Research"]
            ),
            Article(
                title: "Sustainable Cities: Copenhagen's Green Revolution",
                summary: "Denmark's capital achieves carbon neutrality milestone through innovative urban planning and green technology.",
                content: """
                Copenhagen has officially achieved carbon neutrality, becoming the first major capital city to reach this ambitious environmental goal through a combination of renewable energy, sustainable transportation, and innovative urban design.
                
                The Danish capital's transformation began over a decade ago with comprehensive planning that integrated environmental sustainability into every aspect of city life. Today, renewable energy sources power 100% of the city's electricity needs.
                
                "This achievement proves that economic prosperity and environmental responsibility are not mutually exclusive," declares Mayor Lars Hansen. "Our green transition has created jobs and improved quality of life."
                
                The city's success stems from multiple initiatives: extensive bicycle infrastructure that makes cycling the preferred mode of transport for 62% of residents, district heating systems powered by biomass and waste incineration, and green building standards that require new construction to meet strict energy efficiency criteria.
                
                Copenhagen's harbor, once heavily polluted, is now clean enough for swimming. Urban parks and green spaces have increased by 40%, improving air quality and providing recreation areas.
                
                The economic impact has been substantial. Green technology companies have flocked to the city, creating thousands of high-skilled jobs. Tourism has increased as visitors come to experience the world's most sustainable capital.
                
                Other cities are studying Copenhagen's model. Delegations from around the world regularly visit to learn how to replicate its success. The city has become a living laboratory for sustainable urban development.
                
                However, challenges remain. Housing affordability has become an issue as the city's desirability drives up property prices. City planners are working on solutions to ensure sustainability includes social equity.
                """,
                category: .lifestyle,
                source: "Global Cities Magazine",
                author: "Emma Larsen",
                readingTime: 5,
                tags: ["Sustainability", "Environment", "Urban Planning", "Green Technology"]
            ),
            Article(
                title: "Mars Mission: New Discoveries Reshape Understanding",
                summary: "NASA's Perseverance rover uncovers geological formations suggesting ancient water systems far more extensive than previously believed.",
                content: """
                NASA's Perseverance rover has discovered geological formations on Mars that suggest the planet once hosted extensive water systems, fundamentally altering our understanding of the Red Planet's history and potential for ancient life.
                
                The rover's instruments detected layered sedimentary rocks and mineral deposits typically formed in the presence of long-lasting bodies of water. These formations span a much larger area than previous discoveries, indicating that ancient Mars may have been far more hospitable than scientists imagined.
                
                "What we're seeing suggests not just isolated lakes, but an interconnected water system that persisted for millions of years," explains Dr. Patricia Gonzales, mission science lead. "This dramatically expands the possible habitats where life could have emerged."
                
                The discoveries include clay minerals that form only in neutral-pH water, similar to conditions in Earth's lakes and rivers. Organic compounds have also been detected, though scientists caution these could have non-biological origins.
                
                Perseverance has been carefully collecting and caching rock samples that will be returned to Earth by future missions for detailed laboratory analysis. These samples could provide definitive answers about whether life ever existed on Mars.
                
                The rover's findings have energized the scientific community and raised new questions about planetary evolution. Understanding how Mars lost its water and atmosphere could provide insights into Earth's long-term climate stability.
                
                Future missions are being planned to explore the newly identified areas of interest. The European Space Agency and NASA are collaborating on a sample return mission scheduled for the early 2030s.
                
                Public interest in Mars exploration has surged following the announcements, with educational institutions reporting increased enrollment in planetary science programs.
                """,
                category: .science,
                source: "Space Exploration Quarterly",
                author: "David Thompson",
                readingTime: 6,
                tags: ["Space", "Mars", "NASA", "Science", "Exploration"]
            ),
            Article(
                title: "The Rise of Independent Cinema",
                summary: "Film festivals report record attendance as audiences embrace innovative storytelling outside Hollywood mainstream.",
                content: """
                Independent cinema is experiencing a renaissance, with film festivals worldwide reporting record attendance and streaming platforms investing heavily in original content from emerging filmmakers.
                
                The Sundance Film Festival's latest edition saw a 45% increase in submissions and sold-out screenings across categories. Similar trends are evident at Cannes, Toronto, and Berlin film festivals.
                
                "Audiences are hungry for authentic, diverse voices and stories that challenge conventional narratives," notes festival director Maria Santos. "Independent films are filling that need."
                
                The shift reflects changing viewer preferences and new distribution models. Streaming platforms have democratized access to independent films, allowing them to reach global audiences without traditional theatrical releases.
                
                Several factors drive this trend: sophisticated audiences seeking alternatives to franchise films, lower production costs making filmmaking more accessible, and social media enabling direct filmmaker-audience connections.
                
                Emerging filmmakers from underrepresented communities are gaining prominence, bringing fresh perspectives to cinema. Their work often tackles contemporary social issues with nuance and creativity.
                
                Industry veterans are taking notice. Established actors and directors are increasingly participating in independent projects, attracted by creative freedom and compelling scripts.
                
                However, financial sustainability remains challenging. While streaming deals provide some revenue, independent filmmakers still struggle to fund projects and earn sustainable incomes.
                
                Film schools report increased enrollment as aspiring creators see viable pathways to careers in independent cinema. New programs focus on entrepreneurial skills alongside traditional filmmaking craft.
                """,
                category: .entertainment,
                source: "Cinema Arts Review",
                author: "Alexandra Kim",
                readingTime: 4,
                tags: ["Film", "Cinema", "Entertainment", "Arts", "Culture"]
            )
        ]
    }
}

