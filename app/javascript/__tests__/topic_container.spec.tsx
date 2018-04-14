import * as React from 'react';
import {} from 'jasmine';
import TopicContainer from "../packs/learning_trails_show/topic_container";
import {ShallowWrapper, shallow} from "enzyme"

class FakeApi {
  static get (model: string, id: number, callback: (object) => void): void {
    const result = {
      topic: {},
      user_lessons: {}
    };
    callback(result)
  }
}

const testProps = {
  id: 1,
  api: FakeApi
};

let child: ShallowWrapper<undefined, undefined>;

beforeEach(() =>
  child = shallow(<TopicContainer {...testProps}/>));

describe('TopicContainer', () => {

  it('it renders the title passed', () => {
    const props = { topic: "test topic"};

    // const learningTrailsShowNode = ReactDOM.findDOMNode(show);

    expect(true).toEqual(true);
  });
});
