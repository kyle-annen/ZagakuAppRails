import * as React from 'react';
import {} from 'jasmine';
import {ShallowWrapper, shallow, HTMLAttributes} from "enzyme"
import TopicContainer from "../../packs/learning_trails_show/topic_container";
import {IApi} from "../../apis/iapi";

const testProps = {
  id: 1,
  api: new FakeApi
};

let wrapper: ShallowWrapper<undefined, undefined>;

beforeEach(() =>
  wrapper = shallow(<TopicContainer {...testProps}/>));

describe('TopicContainer', () => {

  it("should render without error", () => {
    expect(wrapper.length).toBe(1);
  });

  it('render the title from api call', () => {
    const expected = <h2 className="topic-page-title">Test Title</h2>;

    expect(wrapper.contains(expected)).toBeTruthy();
  });
});
