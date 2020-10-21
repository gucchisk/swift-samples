import Foundation
import SwiftSoup

print("Hello, world!")

let baseUrl = "https://www.bousai.metro.tokyo.lg.jp/taisaku/saigai/1010035/"
let reportPageKeyword = "新型コロナウイルスに関連した患者の発生について"

func getSwiftSoupDoc(url: URL) throws -> Document {
    let html = try String(contentsOf: url, encoding: .utf8)
    return try SwiftSoup.parse(html)
}

func getLatestReportPageURL() throws -> URL? {
    let url = URL(string: "https://www.bousai.metro.tokyo.lg.jp/taisaku/saigai/1010035/index.html")!
    let doc = try getSwiftSoupDoc(url: url)
    let links = try doc.select("a")
    for link in links.array() {
        if try link.text().contains("最新の本部報") {
            let path = try link.attr("href")
            return URL(string: path, relativeTo: url)
        }
    }
    return nil
}

func getCovidReportPageURL(url: URL) throws -> URL? {
    let doc = try getSwiftSoupDoc(url: url)
    let links = try doc.select("a")
    for link in links.array() {
        if try link.text().contains(reportPageKeyword) {
            let path = try link.attr("href")
            return URL(string: path, relativeTo: url)
        }
    }
    return nil
}

// func getPdfURL(url: URL) throws -> URL? {
// }

func main() {
    do {
        guard let reportURL = try getLatestReportPageURL() else {
            return
        }
        print(reportURL)
        guard let detailPageURL = try getCovidReportPageURL(url: reportURL) else {
            return
        }
        print(detailPageURL)
    } catch Exception.Error(let type, let message) {
        print(message)
    } catch {
        print("error")
    }
}

main()
