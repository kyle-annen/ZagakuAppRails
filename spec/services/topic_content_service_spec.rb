require 'rails_helper'
include TopicContentService
include TopicService


RSpec.describe TopicContentService do
  before(:each) do
    test_topics = [{
      name: 'testing.md',
      path: 'clean-code/testing.md',
      sha: '6093e4475780d1bd154c37166dd3fa82d1e29525',
      size: 2035,
      url: '',
      html_url: '',
      git_url: '',
      download_url: '',
      type: 'file'
    }]
    TopicService.save_topics(test_topics)

    mock_topic_content = "# Clojure\n\nA dynamic, general-purpose functional programming language with facilities for polymorphism, concurrency, and metaprogramming (via macros). Hosted on the JVM.\n\n\n## Level 1\n\n* Complete the [Clojure Koans](http://clojurekoans.com/)\n* Solve a few [4Clojure exercises](https://www.4clojure.com/)\n* Read Chapters 1-8 of [Clojure for the Brave and True](http://www.braveclojure.com/clojure-for-the-brave-and-true/)\n* Read the [rationale for Clojure](http://clojure.org/about/rationale)\n\n### You should be able to\n\n* Use [Leiningen](http://leiningen.org/) to create and run projects.\n* Use `lein repl` to try things out.\n* Define and invoke functions.\n* Use sequence and collection functions.\n\n\n## Level 2\n\n* Solve a total of 100 [4Clojure exercises](https://www.4clojure.com/)\n* Read Chapters 9-13 of [Clojure for the Brave and True](http://www.braveclojure.com/clojure-for-the-brave-and-true/)\n* Read [Living Clojure](http://amzn.to/22rM4we)\n* Read [Clojure Programming](http://amzn.to/1UYOraD)\n\n### You should be able to\n\n* Solve small problems with Clojure.\n* Use JVM interop to interact with libraries.\n* Use polymorphism to make your programs conform to the SOLID principles.\n\n\n## Level 3\n\n* Write a Tic-Tac-Toe game or HTTP server in Clojure\n* Contribute to an open-source Clojure project like [Leiningen](https://github.com/technomancy/leiningen/issues)\n* Read [The Joy of Clojure](http://amzn.to/1T1Iard)\n* Read [Mastering Clojure Macros](https://pragprog.com/book/cjclojure/mastering-clojure-macros)\n\n### You should be able to\n\n* Understand any of the language's docstrings.\n* Write entire programs in Clojure.\n* Write your own macros, and know when to avoid it.\n"

    allow(TopicContentService)
      .to receive(:get_raw_content)
      .and_return(mock_topic_content)
  end

  after(:each) do
    Category.destroy_all
  end

  describe 'save_topic_content' do
    it '' do
      content = TopicContentService.get_raw_content('');
      ap content
    end
  end
end
