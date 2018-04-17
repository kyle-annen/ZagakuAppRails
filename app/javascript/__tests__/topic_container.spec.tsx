import * as React from 'react';
import {} from 'jasmine';
import {ShallowWrapper, shallow, mount, ReactWrapper} from "enzyme"
import TopicContainer from "../packs/learning_trails_show/topic_container";
import {IApi} from "../apis/iapi";


class FakeApi implements IApi {
  get (model: string, id: number) {
    return new Promise(() => {
      return {
        topic: {
          id: id,
          category_id: 1,
          name: "Test Title",
          summary: "Test Summary"
        },
        user_lessons: {},
        parameters: {model: model, id: id}
      }
    });
  }
}


const testProps = {
  id: 1,
  api: new FakeApi
};

let wrapper: ReactWrapper<undefined, undefined>;

beforeEach(() => {
  wrapper = mount(<TopicContainer {...testProps}/>);
  wrapper.setProps({...testProps});
});

describe('TopicContainer', () => {

  it("should render without error", () => {
    expect(wrapper.length).toBe(1);
  });

  it('contains title child', () => {
    const selector = '.topic-page-title';
    const rendered = wrapper.render();
    expect(rendered.children(selector)).toBeTruthy();
    expect(rendered.children(selector).text()).toBe("");
  });

  it('contains summary child', () => {
    const selector = '.topic-page-summary';
    const rendered = wrapper.render();
    expect(rendered.children(selector)).toBeTruthy();
    expect(rendered.children(selector).text()).toBe("");
  });
});
