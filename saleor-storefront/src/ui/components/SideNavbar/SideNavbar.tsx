import type { ReactNode, ComponentProps } from "react";
import { NavCollapsible, NavCollapsibleContent, NavCollapsibleTrigger } from "./SideNavCollapsible";
import { type MenuItem, MenuGetBySlugDocument } from "@/gql/graphql";
import { executeGraphQL } from "@/lib/graphql";
import { LinkWithChannel } from "@/ui/atoms/LinkWithChannel";
import { cn } from "@/lib/utils";

type SideNavbarProps = ComponentProps<"aside"> & {
	channel: string;
};

export async function SideNavbar({ channel, className, ...props }: SideNavbarProps) {
	const { menu } = await executeGraphQL(MenuGetBySlugDocument, {
		variables: { slug: "sidebar", channel },
		revalidate: 60 * 60 * 24,
	});

	const RenderItems = ({ items }: { items: MenuItem[] }): ReactNode =>
		items.map((item) => {
			const title = (
				<div className="flex cursor-pointer items-center gap-2 p-2 text-gray-600 hover:text-orange-500">
					<span
						className="[&>svg]:h-6 [&>svg]:w-6"
						dangerouslySetInnerHTML={{
							__html:
								item.category?.metafields?.icon ||
								item.collection?.metafields?.icon ||
								item.page?.metafields?.icon ||
								"<svg></svg>",
						}}
					/>
					{item.name}
				</div>
			);

			if (item?.children?.length && item.children.length > 0)
				return (
					<NavCollapsible key={item.id}>
						<NavCollapsibleTrigger>{title}</NavCollapsibleTrigger>
						<NavCollapsibleContent>
							<div className="ms-8 flex flex-col">
								{item.children && <RenderItems items={item.children} />}
							</div>
						</NavCollapsibleContent>
					</NavCollapsible>
				);

			if (item?.category)
				return (
					<LinkWithChannel key={item.id} href={`/categories/${item.category.slug}`}>
						{title}
					</LinkWithChannel>
				);

			if (item?.collection)
				return (
					<LinkWithChannel key={item.id} href={`/collections/${item.collection.slug}`}>
						{title}
					</LinkWithChannel>
				);

			if (item?.page)
				return (
					<LinkWithChannel key={item.id} href={`/pages/${item.page.slug}`}>
						{title}
					</LinkWithChannel>
				);

			if (item?.url)
				return (
					<LinkWithChannel key={item.id} href={item.url}>
						{" "}
						{title}{" "}
					</LinkWithChannel>
				);

			return null;
		});

	return (
		<aside {...props} id="default-sidebar" className={cn(className)} aria-label="Sidebar">
			{menu?.items &&
				menu.items.map((item) => (
					<div key={item.id} className="text-gray-700 decoration-dashed">
						<div className="mb-2 border-b-2 border-dashed border-orange-500 pb-2 font-semibold">
							{item.name}
						</div>
						{item?.children && <RenderItems items={item.children as MenuItem[]} />}
					</div>
				))}
		</aside>
	);
}
